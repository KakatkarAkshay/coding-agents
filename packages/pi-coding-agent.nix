{ lib, callPackage }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "pi-coding-agent";
  version = "0.74.1";
  owner = "earendil-works";
  repo = "pi";
  binaryName = "pi";
  mainProgram = "pi";
  description = "Pi minimal terminal coding agent";
  homepage = "https://github.com/earendil-works/pi";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "pi-darwin-arm64.tar.gz"; hash = "sha256-4bN/lRVEZQg2taQt/qT6TPZTHkQRHoXtKd+PQfbISjU="; };
    x86_64-darwin = { asset = "pi-darwin-x64.tar.gz"; hash = "sha256-T3Otj26iCXx6bUjHeyIpdnfWsLCt+1SoJVgq0n5b7v8="; };
    x86_64-linux = { asset = "pi-linux-x64.tar.gz"; hash = "sha256-iSNeJCJTugRrZVrmPgaF2ReX2Uuv5rF9tJEiDSpEO5k="; };
    aarch64-linux = { asset = "pi-linux-arm64.tar.gz"; hash = "sha256-/FJtBdz16VgwVQrncfjulWBwNTYMoRkbKzm/PygQj/s="; };
  };
}
