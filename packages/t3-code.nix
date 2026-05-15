{ lib, stdenv, callPackage, appimageTools, fetchurl }:

let
  mkDarwinApp = callPackage ../lib/darwin-app.nix { };
  version = "0.0.24";
in
if stdenv.hostPlatform.isDarwin then
  mkDarwinApp
  {
    pname = "t3-code";
    inherit version;
    owner = "pingdotgg";
    repo = "t3code";
    appName = "T3 Code (Alpha)";
    description = "T3 Code desktop coding agent app";
    homepage = "https://github.com/pingdotgg/t3code";
    license = lib.licenses.unfree;
    sources = {
      aarch64-darwin = { asset = "T3-Code-${version}-arm64.zip"; hash = "sha256-+tJJuna5oCeFUjr+sVBhK/ISw6Jg4uQAqihrW/DHrfM="; };
      x86_64-darwin = { asset = "T3-Code-${version}-x64.zip"; hash = "sha256-sUn07UxtBbly3C6RsDPi2nWSFRtSe5cq5kXH4AdEFqU="; };
    };
  }
else if stdenv.hostPlatform.system == "x86_64-linux" then
  appimageTools.wrapType2
  {
    pname = "t3-code";
    inherit version;
    src = fetchurl {
      url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
      hash = "sha256-t8KYAtaQKWmCVOOwvHByosYoqb0Ji35Qe4m+8Gtp/+k=";
    };
    meta = with lib; {
      description = "T3 Code desktop coding agent app";
      homepage = "https://github.com/pingdotgg/t3code";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
      mainProgram = "t3-code";
    };
  }
else throw "t3-code is not supported on ${stdenv.hostPlatform.system}"
