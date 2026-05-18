{ lib, stdenv, callPackage, appimageTools, fetchurl }:

let
  mkDarwinApp = callPackage ../lib/darwin-app.nix { };
  version = "1.15.5";
  linuxSources = {
    x86_64-linux = { asset = "opencode-desktop-linux-x86_64.AppImage"; hash = "sha256-u2lRmAHsYZz5q+PSwv0KKv6uq3dj0iovOjy77Cp+0V8="; };
    aarch64-linux = { asset = "opencode-desktop-linux-arm64.AppImage"; hash = "sha256-qp3eNxXh7FKY7mZXskxmTj4rAJXRXwFr4x0oXxuBlrY="; };
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
      aarch64-darwin = { asset = "opencode-desktop-mac-arm64.app.tar.gz"; hash = "sha256-FV08vk2mlTF3xzQtg43D/CHS1fY/vTvj/ALcqHi+Ty0="; };
      x86_64-darwin = { asset = "opencode-desktop-mac-x64.app.tar.gz"; hash = "sha256-EDKm0zxogfcyvH+BJnJ69NMW+a7ip+ClvH3HUxYUsJ8="; };
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
