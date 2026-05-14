{ lib, callPackage }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "pi-coding-agent";
  version = "0.74.0";
  owner = "earendil-works";
  repo = "pi";
  binaryName = "pi";
  mainProgram = "pi";
  description = "Pi minimal terminal coding agent";
  homepage = "https://github.com/earendil-works/pi";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "pi-darwin-arm64.tar.gz"; hash = "sha256-MGMXmCPGqYVjQxIkDFcBUCQxb3/mZh7dQfFMd9ixXhA="; };
    x86_64-darwin = { asset = "pi-darwin-x64.tar.gz"; hash = "sha256-+mXJjyxlHsL4n7Goo9ybmHlHvJsQI2Gi8XiGKrrMdWA="; };
    x86_64-linux = { asset = "pi-linux-x64.tar.gz"; hash = "sha256-1nZXow1JyfrKgIaNKkvbpN/KwEcCiT9FptFLJJNF640="; };
    aarch64-linux = { asset = "pi-linux-arm64.tar.gz"; hash = "sha256-JhqpEoeMqYPJA9nEoECDEN2GN7WDCFZR2bXdtwyd9XI="; };
  };
}
