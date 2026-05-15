{ lib, stdenv, callPackage, appimageTools, fetchurl }:

let
  mkDarwinApp = callPackage ../lib/darwin-app.nix { };
  version = "1.15.0";
  linuxSources = {
    x86_64-linux = { asset = "opencode-desktop-linux-x86_64.AppImage"; hash = "sha256-eqcwdZ0wvfe4hlY9VsOzXwPeBO3MMr9FMyda5PyrEiw="; };
    aarch64-linux = { asset = "opencode-desktop-linux-arm64.AppImage"; hash = "sha256-sqshbN+j2UtPyv5XocgPN292nzlttRL5VXoAoln60Pc="; };
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
      aarch64-darwin = { asset = "opencode-desktop-mac-arm64.app.tar.gz"; hash = "sha256-ZpZ4mzEVR+OFTL6WQ+Fej8GcD9ZnAwsJfY4J+aC85j8="; };
      x86_64-darwin = { asset = "opencode-desktop-mac-x64.app.tar.gz"; hash = "sha256-NUXmpc+C6rCuEvtRjPyDDulgzxtGarOb1GhQYppxkgE="; };
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
