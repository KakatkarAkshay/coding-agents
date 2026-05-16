{ lib, stdenv, callPackage, unzip, autoPatchelfHook, makeWrapper }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "opencode";
  version = "1.15.3";
  owner = "anomalyco";
  repo = "opencode";
  binaryName = "opencode";
  description = "OpenCode terminal coding agent";
  homepage = "https://opencode.ai";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "opencode-darwin-arm64.zip"; hash = "sha256-UIeFOiasq3c59nZTLq8m8UZDRaDd2WMx5JC4bevLS6I="; };
    x86_64-darwin = { asset = "opencode-darwin-x64.zip"; hash = "sha256-0HuZlvW9FJ1W+H5Fbq/KOJBgIYriFAA9AomjcyHVEWA="; };
    x86_64-linux = { asset = "opencode-linux-x64.tar.gz"; hash = "sha256-+K6GeMm8zbr5l3fzb/LV7+aJ1HM4Ty6UuE1s2iVtJUA="; };
    aarch64-linux = { asset = "opencode-linux-arm64.tar.gz"; hash = "sha256-Tyo+MEDG3GcXlhsQNOeuZRlAxEkGXTFsbG4XpLeCk9o="; };
  };
}
