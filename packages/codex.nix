{ lib, stdenv, fetchurl, autoPatchelfHook, stdenvNoCC }:

let
  version = "0.129.0";
  tag = "rust-v${version}";
  sources = {
    aarch64-darwin = { target = "aarch64-apple-darwin"; hash = "sha256-Fj/72NP0nQeY1cIiT8auqJhd+/l0fxb7VEIMtN43OxU="; };
    x86_64-darwin = { target = "x86_64-apple-darwin"; hash = "sha256-NXOKHW/1UUeNeBrX4d5ssIg8UoKWvyQ0svwVdKAL2C4="; };
    x86_64-linux = { target = "x86_64-unknown-linux-musl"; hash = "sha256-Skoo0i3R+HTix7I9m6E9sCv3rU7ppwucTqq2GHCNBYI="; };
    aarch64-linux = { target = "aarch64-unknown-linux-musl"; hash = "sha256-YO2eVVaaTCh9ASzfvUN0Kiv7EwZz4ixjtrs4xo+qc2A="; };
  };
  source = sources.${stdenv.hostPlatform.system} or (throw "codex is not supported on ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "codex";
  inherit version;

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/${tag}/codex-${source.target}.tar.gz";
    hash = source.hash;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  sourceRoot = ".";
  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    install -Dm755 codex-${source.target} $out/bin/codex
    runHook postInstall
  '';

  meta = with lib; {
    description = "OpenAI Codex CLI coding agent";
    homepage = "https://github.com/openai/codex";
    license = licenses.asl20;
    platforms = builtins.attrNames sources;
    mainProgram = "codex";
  };
}
