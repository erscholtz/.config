{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  programs.sway.enable = true;

  environment.etc."sway/config.d/10-keyboard.conf".text = ''
    # Muhenkan is mapped to Super_L/Mod4 by the hhkb XKB layout below.
    set $mod Mod4

    input type:keyboard {
      xkb_layout hhkb
    }
  '';

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
}
