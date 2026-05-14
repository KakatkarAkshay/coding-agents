{ lib, stdenv, callPackage, unzip, autoPatchelfHook, makeWrapper }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "opencode";
  version = "1.14.49";
  owner = "anomalyco";
  repo = "opencode";
  binaryName = "opencode";
  description = "OpenCode terminal coding agent";
  homepage = "https://opencode.ai";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "opencode-darwin-arm64.zip"; hash = "sha256-qSrf1evYWaP5oFQ1CHrf9NZY4S0J8IFWMn3ngoNX1G4="; };
    x86_64-darwin = { asset = "opencode-darwin-x64.zip"; hash = "sha256-YA2ieSuLlxV3QhkyZundKep68RsdE0chV4t10CmNPxQ="; };
    x86_64-linux = { asset = "opencode-linux-x64.tar.gz"; hash = "sha256-Czc9ZGUAc982YWrxicGM7Ko9XNGa4hITAMr+0e+lSxE="; };
    aarch64-linux = { asset = "opencode-linux-arm64.tar.gz"; hash = "sha256-t+bL3yfAMMcoRjGcUhP45q+U76gx7Nnt0vMiO4et6uc="; };
  };
}
