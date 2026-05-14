{ lib, stdenv, fetchurl, makeBinaryWrapper, nodejs_20 }:

stdenv.mkDerivation {
  pname = "gemini-cli";
  version = "0.41.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.41.0.tgz";
    hash = "sha512-WPocdkLEXybkmhBPr/MnebsjW7uJ2kmtVIY+zcSh5dlioD8Vyxz/KFn3SpK4NWirYIWvdP/xJbxIUvu6jg9ezA==";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/gemini-cli $out/bin
    cp -R . $out/lib/gemini-cli
    makeBinaryWrapper ${nodejs_20}/bin/node $out/bin/gemini \
      --add-flags "$out/lib/gemini-cli/bundle/gemini.js"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Google Gemini CLI coding agent";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "gemini";
  };
}
