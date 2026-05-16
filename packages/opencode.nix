{ lib, stdenv, callPackage, unzip, autoPatchelfHook, makeWrapper }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "opencode";
  version = "1.15.1";
  owner = "anomalyco";
  repo = "opencode";
  binaryName = "opencode";
  description = "OpenCode terminal coding agent";
  homepage = "https://opencode.ai";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "opencode-darwin-arm64.zip"; hash = "sha256-jpZIKcpnuiI0fMe1BPSrILXOFfnx252jfvRnk1h6ZaA="; };
    x86_64-darwin = { asset = "opencode-darwin-x64.zip"; hash = "sha256-XrrATKVMs+9Lja2ISlrsLH8jv38eZ2zJB82PhH/9Y8k="; };
    x86_64-linux = { asset = "opencode-linux-x64.tar.gz"; hash = "sha256-8jvKuvPy+ptmuAEYE2BlAYhapr/fMQMNTAYb0XXhgwA="; };
    aarch64-linux = { asset = "opencode-linux-arm64.tar.gz"; hash = "sha256-WL3XJxiBcEP54zKMn3isxsZn3Sbl/QE6bPPANZPeI3Q="; };
  };
}
