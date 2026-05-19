{
  description = "Fast-moving AI coding agent packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlay = final: prev: {
        claude-code = final.callPackage ./packages/claude-code.nix { };
        codex = final.callPackage ./packages/codex.nix { };
        codex-app = final.callPackage ./packages/codex-app.nix { };
        gemini-cli = final.callPackage ./packages/gemini-cli.nix { };
        opencode = final.callPackage ./packages/opencode.nix { };
        opencode-desktop = final.callPackage ./packages/opencode-desktop.nix { };
        pi-coding-agent = final.callPackage ./packages/pi-coding-agent.nix { };
        t3-code = final.callPackage ./packages/t3-code.nix { };
      };
      packageNames = [
        "claude-code"
        "codex"
        "codex-app"
        "gemini-cli"
        "opencode"
        "opencode-desktop"
        "pi-coding-agent"
        "t3-code"
      ];
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ overlay ];
          };
          available = builtins.filter (name: pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.${name}) packageNames;
        in
        {
          packages = pkgs.lib.genAttrs available (name: pkgs.${name}) // {
            default = pkgs.claude-code;
          };

          apps = pkgs.lib.genAttrs available
            (name: {
              type = "app";
              program = "${pkgs.${name}}/bin/${pkgs.${name}.meta.mainProgram or name}";
            }) // {
            default = {
              type = "app";
              program = "${pkgs.claude-code}/bin/claude";
            };
          };

          checks = pkgs.lib.genAttrs available (name: pkgs.${name});

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              curl
              gh
              jq
              nixpkgs-fmt
            ];
          };
        }) // {
      overlays.default = overlay;
    };
}
