{ lib, stdenv, callPackage, appimageTools, fetchurl }:

let
  mkDarwinApp = callPackage ../lib/darwin-app.nix { };
  version = "1.15.4";
  linuxSources = {
    x86_64-linux = { asset = "opencode-desktop-linux-x86_64.AppImage"; hash = "sha256-13xEUmoFVKBEG/V+bKQLFOyPE05RxF58jxgIFP269VQ="; };
    aarch64-linux = { asset = "opencode-desktop-linux-arm64.AppImage"; hash = "sha256-8/BOJhTJ3Hr0IDATuOi14C3DpkhiI2T/PboSzkbUqIs="; };
  };
  linuxSource = linuxSources.${stdenv.hostPlatform.system} or null;
in
if stdenv.hostPlatform.isDarwin then
  mkDarwinApp
  {
    pname = "opencode-desktop";
    inherit version;
    owner = "anomalyco";
    repo = "opencode";
    appName = "OpenCode";
    description = "OpenCode desktop app";
    homepage = "https://opencode.ai";
    license = lib.licenses.mit;
    sources = {
      aarch64-darwin = { asset = "opencode-desktop-mac-arm64.app.tar.gz"; hash = "sha256-bv/oQNHWvQdiXNOKagIGZDUK9exDRF11ZXgEqeDtyGk="; };
      x86_64-darwin = { asset = "opencode-desktop-mac-x64.app.tar.gz"; hash = "sha256-BLIfrlDuEx2lrhmJ7X1/0f9sK0x63/yfwTaHQ8BMUjs="; };
    };
  }
else if linuxSource != null then
  appimageTools.wrapType2
  {
    pname = "opencode-desktop";
    inherit version;
    src = fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/${linuxSource.asset}";
      hash = linuxSource.hash;
    };
    meta = with lib; {
      description = "OpenCode desktop app";
      homepage = "https://opencode.ai";
      license = licenses.mit;
      platforms = builtins.attrNames linuxSources;
      mainProgram = "opencode-desktop";
    };
  }
else throw "opencode-desktop is not supported on ${stdenv.hostPlatform.system}"
