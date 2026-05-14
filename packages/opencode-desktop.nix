{ lib, stdenv, callPackage, appimageTools, fetchurl }:

let
  mkDarwinApp = callPackage ../lib/darwin-app.nix { };
  version = "1.14.50";
  linuxSources = {
    x86_64-linux = { asset = "opencode-desktop-linux-x86_64.AppImage"; hash = "sha256-0awz3nZ2ZjfAcxHDmAAgeCXIfaaXAWi2sIiywN53wbI="; };
    aarch64-linux = { asset = "opencode-desktop-linux-arm64.AppImage"; hash = "sha256-ZgIvGrZvYyKOpjxRn8u6v1TggHwr9/ffoNbEpOEJi6Y="; };
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
      aarch64-darwin = { asset = "opencode-desktop-mac-arm64.app.tar.gz"; hash = "sha256-KeFe/xG3EvAKjM2OPyvMEelkCFT7yMLVYiMXXGDkhC0="; };
      x86_64-darwin = { asset = "opencode-desktop-mac-x64.app.tar.gz"; hash = "sha256-O9ydLPJPy25Uz6SqMeSPnec6QyxJPIbXyDmCLTAGjqs="; };
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
