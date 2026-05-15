{ lib, stdenv, callPackage, unzip, autoPatchelfHook, makeWrapper }:

let
  mkArchivePackage = callPackage ../lib/archive-package.nix { };
in
mkArchivePackage {
  pname = "opencode";
  version = "1.14.51";
  owner = "anomalyco";
  repo = "opencode";
  binaryName = "opencode";
  description = "OpenCode terminal coding agent";
  homepage = "https://opencode.ai";
  license = lib.licenses.mit;
  sources = {
    aarch64-darwin = { asset = "opencode-darwin-arm64.zip"; hash = "sha256-FEuggefMWVMgkPRFciDITcW2YtqIIBiyWik06FlKVFQ="; };
    x86_64-darwin = { asset = "opencode-darwin-x64.zip"; hash = "sha256-IapFX2xmD07FftUP++xrt2CJwFgkhxQSd33UZ743vJw="; };
    x86_64-linux = { asset = "opencode-linux-x64.tar.gz"; hash = "sha256-j+qZqJYFJvYAEXkmmeBXUpZqSbX9ToXbtCCyhQjg61c="; };
    aarch64-linux = { asset = "opencode-linux-arm64.tar.gz"; hash = "sha256-VqiaEZFfELGuk8vaosUr2COpl/zgdQbt3BR7UjVyMaE="; };
  };
}
