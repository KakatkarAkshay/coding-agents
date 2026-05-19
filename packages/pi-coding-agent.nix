{ lib, callPackage }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "pi-coding-agent";
  version = "0.75.3";
  owner = "earendil-works";
  repo = "pi";
  binaryName = "pi";
  mainProgram = "pi";
  description = "Pi minimal terminal coding agent";
  homepage = "https://github.com/earendil-works/pi";
  license = lib.licenses.mit;
  extraInstall = ''
    candidateDir=$(dirname "$candidate")
    cp -R "$candidateDir"/. "$out/bin/"
  '';
  sources = {
    aarch64-darwin = { asset = "pi-darwin-arm64.tar.gz"; hash = "sha256-LRZmjWJoBepz1DCxeLIvU0EVLHwTVExG+J1oBY4Lv4E="; };
    x86_64-darwin = { asset = "pi-darwin-x64.tar.gz"; hash = "sha256-JDLPC2qYTT+20Cm1/WUIYqQszpIbJb1bbRfOmvzD5po="; };
    x86_64-linux = { asset = "pi-linux-x64.tar.gz"; hash = "sha256-hu9I21upinhKzx284b1tX9W2vuPuLvRJ4IEagtG6eMM="; };
    aarch64-linux = { asset = "pi-linux-arm64.tar.gz"; hash = "sha256-NBOJtZrUpUomgRTE4rTmXgFPl6WB/RTqciwgsziX7s0="; };
  };
}
