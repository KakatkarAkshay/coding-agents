{ lib, stdenv, fetchurl, makeBinaryWrapper, autoPatchelfHook, procps, ripgrep, bubblewrap, socat }:

let
  version = "2.1.141";
  platformMap = {
    aarch64-darwin = "darwin-arm64";
    x86_64-darwin = "darwin-x64";
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
  };
  platform = platformMap.${stdenv.hostPlatform.system} or (throw "claude-code is not supported on ${stdenv.hostPlatform.system}");
  hashes = {
    darwin-arm64 = "0pkhmcf682bihvvjmkaia2zd5gzq9dczzwykvl61sfx336xrbb1i";
    darwin-x64 = "09bwiiamnwxpahhq9f6dfq75vfm2miakaa7a62pzq8m5ykyh147s";
    linux-x64 = "0bmldg2p4w280svyckdqnlfavgy49w1jp8i0wncsxchmixpf4aw3";
    linux-arm64 = "0fy6dhd1hxvhb0ypbsni7rd854w4n1w544b8vk4avyrayqj1x4yw";
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
