# coding-agents

Fast-moving macOS-first Nix packages for coding agents, maintained separately from nixpkgs so releases can be updated quickly.

## Packages

- `claude-code`
- `codex`
- `codex-app`
- `gemini-cli`
- `opencode`
- `opencode-desktop`
- `pi-coding-agent`
- `t3-code`

## Usage

```bash
nix run github:KakatkarAkshay/coding-agents#claude-code
nix run github:KakatkarAkshay/coding-agents#codex
nix run github:KakatkarAkshay/coding-agents#opencode
nix run github:KakatkarAkshay/coding-agents#gemini-cli
nix run github:KakatkarAkshay/coding-agents#pi-coding-agent
```

## Updates

`.github/workflows/update.yml` runs hourly. It updates versions and hashes, commits, and pushes when upstream packages change.
