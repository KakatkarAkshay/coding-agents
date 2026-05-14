#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$repo_root"

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing required command: $1" >&2
    exit 1
  }
}

require gh
require jq
require nix
require curl
require xmllint

to_sri() {
  nix hash convert --hash-algo sha256 --to sri "${1#sha256:}"
}

prefetch_claude_code() {
  local version="$1" platform="$2" hash=""
  for base_url in \
    "https://downloads.claude.ai/claude-code-releases" \
    "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"; do
    hash=$(nix-prefetch-url "$base_url/$version/$platform/claude" 2>/dev/null | tail -1 || true)
    if [ -n "$hash" ]; then
      printf '%s\n' "$hash"
      return 0
    fi
  done
  return 1
}

replace_version() {
  local file="$1" version="$2"
  perl -0pi -e 's/version = "[^"]+";/version = "'"$version"'";/' "$file"
}

replace_tag_version() {
  local file="$1" version="$2"
  perl -0pi -e 's/tag = "rust-v\$\{version\}";/tag = "rust-v\$\{version\}";/' "$file"
  replace_version "$file" "$version"
}

update_claude_code() {
  local latest file
  file=packages/claude-code.nix
  latest=$(npm view @anthropic-ai/claude-code version)
  replace_version "$file" "$latest"
  for platform in darwin-arm64 darwin-x64 linux-x64 linux-arm64; do
    hash=$(prefetch_claude_code "$latest" "$platform")
    perl -0pi -e 's/'"$platform"' = "[^"]+";/'"$platform"' = "'"$hash"'";/' "$file"
  done
}

update_codex() {
  local latest tag json file
  file=packages/codex.nix
  latest=$(npm view @openai/codex version)
  tag="rust-v$latest"
  json=$(gh release view "$tag" --repo openai/codex --json assets)
  replace_version "$file" "$latest"
  for target in aarch64-apple-darwin x86_64-apple-darwin x86_64-unknown-linux-musl aarch64-unknown-linux-musl; do
    digest=$(jq -r --arg name "codex-$target.tar.gz" '.assets[] | select(.name == $name) | .digest' <<<"$json")
    sri=$(to_sri "$digest")
    perl -0pi -e 's/(target = "'"$target"'"; hash = ")[^"]+(";)/$1'"$sri"'$2/' "$file"
  done

  local codex_app_feed codex_app_version codex_app_url codex_app_json codex_app_hash
  codex_app_feed=$(curl -fsSL "https://persistent.oaistatic.com/codex-app-prod/appcast.xml")
  codex_app_version=$(xmllint --xpath 'string(/*[local-name()="rss"]/*[local-name()="channel"]/*[local-name()="item"][1]/*[local-name()="shortVersionString"])' - <<<"$codex_app_feed")
  codex_app_url=$(xmllint --xpath 'string(/*[local-name()="rss"]/*[local-name()="channel"]/*[local-name()="item"][1]/*[local-name()="enclosure"]/@url)' - <<<"$codex_app_feed")
  codex_app_json=$(nix store prefetch-file --json "$codex_app_url")
  codex_app_hash=$(jq -r .hash <<<"$codex_app_json")
  replace_version packages/codex-app.nix "$codex_app_version"
  perl -0pi -e 's|(url = ")[^"]+(";\n\s+hash = ")[^"]+(";)|$1'"$codex_app_url"'$2'"$codex_app_hash"'$3|' packages/codex-app.nix
}

update_opencode() {
  local latest json
  latest=$(npm view opencode-ai version)
  json=$(gh release view "v$latest" --repo anomalyco/opencode --json assets)
  replace_version packages/opencode.nix "$latest"
  replace_version packages/opencode-desktop.nix "$latest"
  while IFS='|' read -r file asset; do
    digest=$(jq -r --arg name "$asset" '.assets[] | select(.name == $name) | .digest' <<<"$json")
    sri=$(to_sri "$digest")
    perl -0pi -e 's/(asset = "'"$asset"'"; hash = ")[^"]+(";)/$1'"$sri"'$2/' "$file"
  done <<'EOF'
packages/opencode.nix|opencode-darwin-arm64.zip
packages/opencode.nix|opencode-darwin-x64.zip
packages/opencode.nix|opencode-linux-x64.tar.gz
packages/opencode.nix|opencode-linux-arm64.tar.gz
packages/opencode-desktop.nix|opencode-desktop-mac-arm64.app.tar.gz
packages/opencode-desktop.nix|opencode-desktop-mac-x64.app.tar.gz
packages/opencode-desktop.nix|opencode-desktop-linux-x86_64.AppImage
packages/opencode-desktop.nix|opencode-desktop-linux-arm64.AppImage
EOF
}

update_gemini_cli() {
  local latest tarball integrity sri
  latest=$(npm view @google/gemini-cli version)
  tarball=$(npm view @google/gemini-cli dist.tarball)
  integrity=$(npm view @google/gemini-cli dist.integrity)
  sri=$(nix hash convert --hash-algo sha512 --to sri "${integrity#sha512-}")
  replace_version packages/gemini-cli.nix "$latest"
  perl -0pi -e 's|(url = ")[^"]+(";\n\s+hash = ")[^"]+(";)|$1'"$tarball"'$2'"$sri"'$3|' packages/gemini-cli.nix
}

update_pi() {
  local tag latest json
  tag=$(gh release view --repo earendil-works/pi --json tagName -q .tagName)
  latest=${tag#v}
  json=$(gh release view "$tag" --repo earendil-works/pi --json assets)
  replace_version packages/pi-coding-agent.nix "$latest"
  for asset in pi-darwin-arm64.tar.gz pi-darwin-x64.tar.gz pi-linux-x64.tar.gz pi-linux-arm64.tar.gz; do
    digest=$(jq -r --arg name "$asset" '.assets[] | select(.name == $name) | .digest' <<<"$json")
    sri=$(to_sri "$digest")
    perl -0pi -e 's/(asset = "'"$asset"'"; hash = ")[^"]+(";)/$1'"$sri"'$2/' packages/pi-coding-agent.nix
  done
}

update_t3_code() {
  local tag latest json
  tag=$(gh release view --repo pingdotgg/t3code --json tagName -q .tagName)
  latest=${tag#v}
  json=$(gh release view "$tag" --repo pingdotgg/t3code --json assets)
  replace_version packages/t3-code.nix "$latest"
  for asset in "T3-Code-$latest-arm64.zip" "T3-Code-$latest-x64.zip" "T3-Code-$latest-x86_64.AppImage"; do
    digest=$(jq -r --arg name "$asset" '.assets[] | select(.name == $name) | .digest' <<<"$json")
    sri=$(to_sri "$digest")
    perl -0pi -e 's/(asset = "'"$asset"'"; hash = ")[^"]+(";)/$1'"$sri"'$2/; s/(T3-Code-\$\{version\}-x86_64\.AppImage";\n\s+hash = ")[^"]+(";)/$1'"$sri"'$2/' packages/t3-code.nix
  done
}

update_claude_code
update_codex
update_opencode
update_gemini_cli
update_pi
update_t3_code

nix flake update
nixpkgs-fmt . >/dev/null 2>&1 || true

if git diff --quiet; then
  echo "No updates found."
else
  git diff --stat
fi
