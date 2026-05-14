{ lib, stdenv, fetchurl, unzip }:

let
  sources = {
    aarch64-darwin = {
      url = "https://persistent.oaistatic.com/codex-app-prod/Codex-darwin-arm64-26.506.31004.zip";
      hash = "sha256-mglSnUk30fJMePeMfvf0tQHFlMVbS+tP7MB20DUk2tU=";
    };
  };
  source = sources.${stdenv.hostPlatform.system} or (throw "codex-app is not supported on ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "codex-app";
  version = "26.506.31004";

  src = fetchurl {
    inherit (source) url hash;
  };

  dontUnpack = true;
  dontStrip = true;
  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications $out/bin unpacked
    unzip -q $src -d unpacked
    app=$(find unpacked -maxdepth 3 -name 'Codex.app' -type d | head -n1)
    if [ -z "$app" ]; then
      echo "Could not find Codex.app" >&2
      find unpacked -maxdepth 3 >&2
      exit 1
    fi
    cp -R "$app" $out/Applications/
    cat > "$out/bin/codex-app" <<EOF
#!/bin/sh
exec open "$out/Applications/Codex.app" --args "\$@"
EOF
    chmod +x $out/bin/codex-app
    runHook postInstall
  '';

  meta = with lib; {
    description = "OpenAI Codex macOS app";
    homepage = "https://developers.openai.com/codex/app";
    license = licenses.unfree;
    platforms = builtins.attrNames sources;
    mainProgram = "codex-app";
  };
}
