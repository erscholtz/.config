{ pkgs, nixpkgs-unstable, t3code, helium, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gh
    nodejs
    pnpm
    python3
    python3Packages.pip
    gcc
    gnumake
    pkg-config
    ghostty
    obsidian
    spotify
    discord
    unstable.zed-editor
    rust-analyzer
    rustc
    cargo
    rustfmt
    clippy
    rustup
    zigpkgs.default

    unstable.neovim
    unstable.codex
    pkgs.codex-acp

    helium.defaultPackage.${system}

    t3code.packages.${system}.t3
    t3code.packages.${system}.t3code
  ];
}
