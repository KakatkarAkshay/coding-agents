{ lib, stdenv, fetchurl, autoPatchelfHook, stdenvNoCC }:

let
  version = "0.130.0";
  tag = "rust-v${version}";
  sources = {
    aarch64-darwin = { target = "aarch64-apple-darwin"; hash = "sha256-vFCkt/mgyMqZF5GJ5GWbYBEHgwdw4hVH3Awka85zNXc="; };
    x86_64-darwin = { target = "x86_64-apple-darwin"; hash = "sha256-/t2xFr2W19g/i7GbNPur5oQ8xkRhuvLknAF+EgatXmc="; };
    x86_64-linux = { target = "x86_64-unknown-linux-musl"; hash = "sha256-Fneee3hXUIp2ijbX1OCE7sM27COUbtcKmwlIm4+GEZA="; };
    aarch64-linux = { target = "aarch64-unknown-linux-musl"; hash = "sha256-HX4A8sIsMBa1vLccYQEJR7AiqQ4pAbxrqv6CJWSSx2c="; };
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
