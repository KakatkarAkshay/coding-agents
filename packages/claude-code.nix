{ lib, stdenv, fetchurl, makeBinaryWrapper, autoPatchelfHook, procps, ripgrep, bubblewrap, socat }:

let
  version = "2.1.144";
  platformMap = {
    aarch64-darwin = "darwin-arm64";
    x86_64-darwin = "darwin-x64";
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
  };
  platform = platformMap.${stdenv.hostPlatform.system} or (throw "claude-code is not supported on ${stdenv.hostPlatform.system}");
  hashes = {
    darwin-arm64 = "1px5fq9g6naz00qv1knzwmvfx4r1fchz2r442235yiacxjjbm1lq";
    darwin-x64 = "1y47f28lw80j9c8smjywchy12awlh1igpg6fakdcw59nf5xw09fj";
    linux-x64 = "0khbyahdanxj4v1q9yiy47kl94r9x6rifdp8sl7p5rbj8ivq0x0l";
    linux-arm64 = "04s5f3ibv1kg0srbx1iwrx6n2bqkjiikdbykidc89mhjrszwrk68";
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
