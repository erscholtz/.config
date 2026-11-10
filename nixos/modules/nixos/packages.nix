{ pkgs, lib, nixpkgs-unstable, t3code, helium, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  allTargetBinutils = pkgs.binutils-unwrapped-all-targets;

  wildGcc = pkgs.writeShellApplication {
    name = "gcc";
    text = ''
      exec ${lib.getExe pkgs.gcc} "$@" -B${allTargetBinutils}/bin
    '';
  };

  wildGpp = pkgs.writeShellApplication {
    name = "g++";
    text = ''
      exec ${lib.getExe' pkgs.gcc "g++"} "$@" -B${allTargetBinutils}/bin
    '';
  };

  wasiLibc = pkgs.pkgsCross.wasi32.wasilibc;

  wasiSysroot = pkgs.runCommand "wild-wasi-sysroot" { } ''
    mkdir -p "$out/include" "$out/lib"
    ln -s ${wasiLibc.dev}/include "$out/include/wasm32-wasi"
    ln -s ${wasiLibc}/lib "$out/lib/wasm32-wasi"
  '';
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
    gnumake
    pkg-config
    ghostty
    obsidian
    spotify
    discord
    rustup
    zigpkgs.default
    qemu
    pkgsCross.riscv64-embedded.buildPackages.gdb # riscv64-none-elf-gdb, for debugging boot0 under qemu -S -s
    zellij


    allTargetBinutils
    cargo-chef
    llvmPackages_20.clang-unwrapped
    clang-tools
    taplo
    lld
    wild
    glibc.out
    glibc.static
    wildGcc
    wildGpp
    wasm-tools
    wasmtime
    wabt

    unstable.neovim
    unstable.zed-editor
    unstable.claude-code
    unstable.codex
    unstable.codex-acp

    helium.defaultPackage.${system}

    t3code.packages.${system}.t3
    t3code.packages.${system}.t3code
  ];

  environment.sessionVariables = {
    WASI_SYSROOT = "${wasiSysroot}";
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ];
  };
}
