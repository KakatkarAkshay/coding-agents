{ lib, callPackage }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "pi-coding-agent";
  version = "0.75.1";
  owner = "earendil-works";
  repo = "pi";
  binaryName = "pi";
  mainProgram = "pi";
  description = "Pi minimal terminal coding agent";
  homepage = "https://github.com/earendil-works/pi";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "pi-darwin-arm64.tar.gz"; hash = "sha256-i/df5S0VQCWWj/71h0x/xn7GWDXZOmVTxrgE0fAiKuk="; };
    x86_64-darwin = { asset = "pi-darwin-x64.tar.gz"; hash = "sha256-TZQ5mxmMjAHurqqtsf86HGKPLFppq3yQ1MBLxrV2zA0="; };
    x86_64-linux = { asset = "pi-linux-x64.tar.gz"; hash = "sha256-dukdMq8S56alXeOxDr84YRzHNB+ZTFh24W5F6Q18rF4="; };
    aarch64-linux = { asset = "pi-linux-arm64.tar.gz"; hash = "sha256-+oBTrsx1v7gEUgXUjmwPSyOGH0jYNREZGVzaCsBJKzs="; };
  };
}
