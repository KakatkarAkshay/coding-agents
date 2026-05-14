{ lib, stdenv, callPackage, unzip, autoPatchelfHook, makeWrapper }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "opencode";
  version = "1.14.50";
  owner = "anomalyco";
  repo = "opencode";
  binaryName = "opencode";
  description = "OpenCode terminal coding agent";
  homepage = "https://opencode.ai";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "opencode-darwin-arm64.zip"; hash = "sha256-pcbZRA1F4YrH2ccWK4NwnYLsGywo5nfTEHwb6jafcs8="; };
    x86_64-darwin = { asset = "opencode-darwin-x64.zip"; hash = "sha256-uZnNNDn0tLdHrC7h3s9sbHIhRx9pUQmzaBZShLMvPtM="; };
    x86_64-linux = { asset = "opencode-linux-x64.tar.gz"; hash = "sha256-FEqM7VA+gdrQsjrRgnN3/ezevMm9WzJXZh8OvHqd6JE="; };
    aarch64-linux = { asset = "opencode-linux-arm64.tar.gz"; hash = "sha256-YO93fcv4sQgNEOYV/wVE2pdc1yuQbQD17nV4vbPNONQ="; };
  };
}
