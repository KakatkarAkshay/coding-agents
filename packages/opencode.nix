{ lib, stdenv, callPackage, unzip, autoPatchelfHook, makeWrapper }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "opencode";
  version = "1.15.5";
  owner = "anomalyco";
  repo = "opencode";
  binaryName = "opencode";
  description = "OpenCode terminal coding agent";
  homepage = "https://opencode.ai";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "opencode-darwin-arm64.zip"; hash = "sha256-nPaKZ/b90KUhLaoPy8o9vAX/94jcbGIUqi8vSnyrqBU="; };
    x86_64-darwin = { asset = "opencode-darwin-x64.zip"; hash = "sha256-+oFoQH/LBu8Ta8mOihiqzwQhF/l8ieyUTg9v6TAmnsk="; };
    x86_64-linux = { asset = "opencode-linux-x64.tar.gz"; hash = "sha256-v2912gibIgc7zyN1TMO+NR9xM2MWTlvc0+SVAcgRscU="; };
    aarch64-linux = { asset = "opencode-linux-arm64.tar.gz"; hash = "sha256-piROzOA/MDqJRfrjMPF5ZEafwHgPo1Vc3oD7l6xG8vs="; };
  };
}
