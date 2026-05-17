{ lib, callPackage }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "pi-coding-agent";
  version = "0.75.0";
  owner = "earendil-works";
  repo = "pi";
  binaryName = "pi";
  mainProgram = "pi";
  description = "Pi minimal terminal coding agent";
  homepage = "https://github.com/earendil-works/pi";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "pi-darwin-arm64.tar.gz"; hash = "sha256-5YRdh150cf6lGv3L8mYVXXACsMqsdVbAj4/jiScKHYc="; };
    x86_64-darwin = { asset = "pi-darwin-x64.tar.gz"; hash = "sha256-vTN639DtycbSgRUwIHFM1cUevWcw15zM4uPiRHxlBog="; };
    x86_64-linux = { asset = "pi-linux-x64.tar.gz"; hash = "sha256-xj3pIqatu1AxrgRvw0HOFdUQIYRgI7xJLf1yVSq3sfA="; };
    aarch64-linux = { asset = "pi-linux-arm64.tar.gz"; hash = "sha256-7s3PaNmBhQji8ritaNkOWvp5IknV8jMSjklUTh5NyS0="; };
  };
}
