{ lib, stdenv, fetchurl, autoPatchelfHook, stdenvNoCC }:

let
  version = "0.131.0";
  tag = "rust-v${version}";
  sources = {
    aarch64-darwin = { target = "aarch64-apple-darwin"; hash = "sha256-WZfiKvGgXsMDvm4GqfjNlQ2jjaS5CbaBl0fxeC5mglw="; };
    x86_64-darwin = { target = "x86_64-apple-darwin"; hash = "sha256-c1kJNRG4uZyO0G9FANIUhRWnGeTCVtXRFelg1LipYws="; };
    x86_64-linux = { target = "x86_64-unknown-linux-musl"; hash = "sha256-9bJnMrdslUN0L3k3p8iPh54AwKc7ZzAIBDpc7mPoNh0="; };
    aarch64-linux = { target = "aarch64-unknown-linux-musl"; hash = "sha256-3+98mLZ70cyFfvXFBbbu54hyYQ5rzcGdwXTWlaVggrY="; };
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
