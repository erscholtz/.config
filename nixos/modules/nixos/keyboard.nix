{ pkgs, ... }:

{
  services.xserver = {
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };

  environment.etc."sway/config.d/10-keyboard.conf".text = ''
    # Muhenkan is mapped to Super_L/Mod4 and Caps Lock to Control by the hhkb XKB layout below.
    set $mod Mod4

    input type:keyboard {
      xkb_layout hhkb
    }
  '';

  services.xserver.xkb = {
    layout = "hhkb";
    variant = "";
    extraLayouts.hhkb = {
      description = "English (US, HHKB Muhenkan as Super, Caps as Ctrl)";
      languages = [ "eng" ];
      symbolsFile = pkgs.writeText "hhkb-symbols" ''
        default partial alphanumeric_keys modifier_keys
        xkb_symbols "basic" {
          include "us(basic)"
          name[Group1] = "English (US, HHKB Muhenkan as Super)";
          replace key <MUHE> { [ Super_L ] };
          modifier_map Mod4 { <MUHE> };

          // Caps Lock acts as Control, like the HHKB layout.
          replace key <CAPS> { [ Control_L, Control_L ] };
          modifier_map Control { <CAPS>, <LCTL> };
        };
      '';
    };
  };
}
