{ config, pkgs, herdr, ... }: {
  home.stateVersion = "25.11";
  home.username = "e";
  home.homeDirectory = "/home/e";
  xdg.enable = true;

  home.sessionVariables = {
    PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi";
    TERMINAL = "ghostty";
  };

  # Default terminal for xdg-terminal-exec and compatible launchers.
  xdg.configFile."xdg-terminals.list".text = "com.mitchellh.ghostty.desktop\n";

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.packages = with pkgs; [
    fzf
    tmux
    herdr.packages.${pkgs.system}.default
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
    shellAliases = {
      btw = "echo I use nix btw";
      ss = "${config.home.homeDirectory}/.config/tmux/sessionizer.sh";
    };
  };

  home.file."Pictures/Wallpapers/wallhaven-e89l8k.jpg".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/wallpapers/wallhaven-e89l8k.jpg";

  xdg.configFile."autostart/set-wallpaper.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=Set Wallpaper
    Exec=${pkgs.bash}/bin/bash -lc "sleep 5 && plasma-apply-wallpaperimage '${config.home.homeDirectory}/Pictures/Wallpapers/wallhaven-e89l8k.jpg'"
    StartupNotify=false
    Terminal=false
    OnlyShowIn=KDE;
  '';

  xdg.configFile."kscreenlockerrc".text = ''
    [Greeter]
    WallpaperPlugin=org.kde.image

    [Greeter][Wallpaper][org.kde.image][General]
    Image=file://${config.home.homeDirectory}/Pictures/Wallpapers/wallhaven-e89l8k.jpg
  '';

  programs.waybar = {
    enable = true;
    settings.main = {
      layer = "top";
      position = "top";
      height = 28;
      modules-left = [ "sway/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "custom/online" "network" "pulseaudio" "battery" "tray" ];

      "sway/workspaces".format = "{name}";

      clock = {
        interval = 1;
        format = "{:%d/%m/%y  %H:%M:%S}";
        tooltip-format = "{:%A, %d %B %Y}";
      };

      network = {
        format-wifi = "󰤨";
        format-ethernet = "󰈀";
        format-disconnected = "󰤭";
        tooltip-format = "{ifname} · {essid} · {ipaddr}\n{signalStrength}%";
        tooltip-format-disconnected = "No connection";
      };

      # Real internet check (the network module only reports link state).
      "custom/online" = {
        exec = "${pkgs.iputils}/bin/ping -c1 -W2 1.1.1.1 >/dev/null && echo '󰖩' || echo '󰖪'";
        interval = 10;
        tooltip = false;
      };

      pulseaudio = {
        format = "{icon}";
        format-muted = "󰝟";
        format-icons.default = [ "󰕿" "󰖀" "󰕾" ];
        tooltip-format = "{volume}%";
      };

      battery = {
        format = "{icon}";
        format-icons = [ "󰁺" "󰁼" "󰁾" "󰂀" "󰁹" ];
        tooltip-format = "{capacity}% · {timeTo}";
      };
    };
    style = ''
      * { font-family: "JetBrainsMono Nerd Font"; font-size: 13pt; }
      #workspaces button, #clock, #custom-online, #network, #pulseaudio, #battery, #tray { padding: 0 8px; margin: 0; min-width: 0; }
      window#waybar { background: #000000; color: #cdcdcd; }
      #workspaces button { padding: 0 8px; color: #878787; }
      #workspaces button.focused { background: #b4a7d6; color: #000000; }
      #network.disconnected { color: #ff6b6b; }
    '';
  };

  # home.file.".local/share/nvim/site/pack/harnessd/start/harnessd".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/dev/harnessd/integrations/nvim";
}
