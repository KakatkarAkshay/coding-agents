{ lib, callPackage }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "pi-coding-agent";
  version = "0.73.1";
  owner = "earendil-works";
  repo = "pi";
  binaryName = "pi";
  mainProgram = "pi";
  description = "Pi minimal terminal coding agent";
  homepage = "https://github.com/earendil-works/pi";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "pi-darwin-arm64.tar.gz"; hash = "sha256-xk9QHK2PoKWBJX3J6HjhsvNR8pXQ2F1XP+jXlnv7G+4="; };
    x86_64-darwin = { asset = "pi-darwin-x64.tar.gz"; hash = "sha256-5Z/e0fefvHsS4mO/Q9HjWK9Zj2+zxNT1jhbRxevmsrU="; };
    x86_64-linux = { asset = "pi-linux-x64.tar.gz"; hash = "sha256-APDbnpP2ujPesbtNdbTq/t6fpTebY1qQjPln1bN+Nm0="; };
    aarch64-linux = { asset = "pi-linux-arm64.tar.gz"; hash = "sha256-9HRVtqf/bkN1KjfHwKCLgFTv2CyuHvwG0AfJTwalYxg="; };
  };
}
