{ lib, stdenv, fetchurl, makeBinaryWrapper, autoPatchelfHook, procps, ripgrep, bubblewrap, socat }:

let
  version = "2.1.142";
  platformMap = {
    aarch64-darwin = "darwin-arm64";
    x86_64-darwin = "darwin-x64";
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
  };
  platform = platformMap.${stdenv.hostPlatform.system} or (throw "claude-code is not supported on ${stdenv.hostPlatform.system}");
  hashes = {
    darwin-arm64 = "0j54xari7c2z6ad1k30y676wmm44vww9fdsdw2bhn5jil2pj283p";
    darwin-x64 = "1za0s8xr0phy7dq630yfvcrmny92d0xjm1nc27l7r0yh73xwc2yh";
    linux-x64 = "1v14rw3j90h9wlfb3pknv8sj9n50l5bvdqfl1cr8zm72vzda2j8j";
    linux-arm64 = "04b4v2zf7dsrx87cybdpy5bb6d7i07jr03xhcgbajg3n53y16yvn";
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
