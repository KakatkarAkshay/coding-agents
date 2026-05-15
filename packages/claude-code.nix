{ lib, stdenv, fetchurl, makeBinaryWrapper, autoPatchelfHook, procps, ripgrep, bubblewrap, socat }:

let
  version = "2.1.143";
  platformMap = {
    aarch64-darwin = "darwin-arm64";
    x86_64-darwin = "darwin-x64";
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
  };
  platform = platformMap.${stdenv.hostPlatform.system} or (throw "claude-code is not supported on ${stdenv.hostPlatform.system}");
  hashes = {
    darwin-arm64 = "1vr2swv8r3f4y1ws3ba50slma50s92k1nsiiy3xgi0w4sv7wc097";
    darwin-x64 = "0b1ndyb0hb3mv173888dqpjwn1i3abwrddcgh0rs0rdp0b7g93xw";
    linux-x64 = "1i6wn6icac5kqzamqkgdf0wnsp2wkcs9wbqrhr5lkkfrz4zxqpzp";
    linux-arm64 = "1sy48sj42fxc8sz6dqh31hrl7imywywd2xbwc0c1vi63lp2fvs1j";
  };
  binary = fetchurl {
    # Primary URL is Anthropic-branded; GCS is the direct origin fallback.
    urls = [
      "https://downloads.claude.ai/claude-code-releases/${version}/${platform}/claude"
      "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/${platform}/claude"
    ];
    sha256 = hashes.${platform};
  };
in
stdenv.mkDerivation {
  pname = "claude-code";
  inherit version;

  dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [ makeBinaryWrapper ] ++ lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 ${binary} $out/bin/.claude-unwrapped
    makeBinaryWrapper $out/bin/.claude-unwrapped $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1 \
      --set DISABLE_INSTALLATION_CHECKS 1 \
      --set USE_BUILTIN_RIPGREP 0 \
      --prefix PATH : ${lib.makeBinPath ([ procps ripgrep ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap socat ])}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Claude Code terminal coding agent";
    homepage = "https://www.anthropic.com/claude-code";
    license = licenses.unfree;
    platforms = builtins.attrNames platformMap;
    mainProgram = "claude";
  };
}
