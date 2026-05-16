{ lib, stdenv, callPackage, unzip, autoPatchelfHook, makeWrapper }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "opencode";
  version = "1.15.2";
  owner = "anomalyco";
  repo = "opencode";
  binaryName = "opencode";
  description = "OpenCode terminal coding agent";
  homepage = "https://opencode.ai";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "opencode-darwin-arm64.zip"; hash = "sha256-zx6ZNh0wCQVdFtFci2kG7rwoEG7P8HSMYpNDr2WceSQ="; };
    x86_64-darwin = { asset = "opencode-darwin-x64.zip"; hash = "sha256-CD9/4Atwy/ixg5YN89v41cNcVPr+zWHLQYtP15j1SJM="; };
    x86_64-linux = { asset = "opencode-linux-x64.tar.gz"; hash = "sha256-ozz+Vy3ROipQBIkf8/Na+DhJlaEk7saoH9zg3ojSqC0="; };
    aarch64-linux = { asset = "opencode-linux-arm64.tar.gz"; hash = "sha256-yU3uIvzhRN2GwGJ5OXQ1OmmtBWBzuQ7MOnhYgBeJ0B8="; };
  };
}
