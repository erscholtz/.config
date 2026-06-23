{ config, pkgs, nixpkgs-unstable, t3code, helium, zig-overlay, ... }:
let 
  system = pkgs.stdenv.hostPlatform.system;

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "thinkbox"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Keep Plasma as the desktop while excluding optional bundled applications.
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    aurorae
    plasma-browser-integration
    plasma-workspace-wallpapers
    konsole
    kwin-x11
    qttools
    ark
    elisa
    gwenview
    okular
    kate
    ktexteditor
    khelpcenter
    dolphin
    baloo-widgets
    dolphin-plugins
    spectacle
    ffmpegthumbs
    krdp
    discover
  ];

  # Use the HHKB Muhenkan thumb key as Super/Mod4.
  services.xserver.xkb = {
    layout = "hhkb";
    variant = "";
    extraLayouts.hhkb = {
      description = "English (US, HHKB Muhenkan as Super)";
      languages = [ "eng" ];
      symbolsFile = pkgs.writeText "hhkb-symbols" ''
        default partial alphanumeric_keys modifier_keys
        xkb_symbols "basic" {
          include "us(basic)"
          name[Group1] = "English (US, HHKB Muhenkan as Super)";
          replace key <MUHE> { [ Super_L ] };
          modifier_map Mod4 { <MUHE> };
        };
      '';
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.e = {
    isNormalUser = true;
    description = "e";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.dolphin
      kdePackages.okular
      kdePackages.ark
      kdePackages.spectacle
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    zig-overlay.overlays.default
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    gh
    nodejs
    pnpm
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
    # harnessd.packages.${system}.default

    helium.defaultPackage.${system}

    #T3Code
    t3code.packages.${system}.t3
    t3code.packages.${system}.t3code
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-generations +10";
  };
  nix.optimise.automatic = true;

  boot.loader.systemd-boot.configurationLimit = 10;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
