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
    copilot-language-server
    herdr.packages.${pkgs.system}.default
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
    shellAliases = {
      btw = "echo I use nix btw";
      ss = "${config.home.homeDirectory}/.config/zellij/sessionizer.sh";
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
      modules-right = [ "custom/online" "network" "cpu" "memory" "pulseaudio" "battery" "tray" ];

      "sway/workspaces".format = "{name}";

      clock = {
        interval = 1;
        format = "{:%Y-%m-%d %H:%M:%S}";
        tooltip-format = "{:%A, %d %B %Y}";
      };

      network = {
        interval = 2;
        format-wifi = "W: {essid} {bandwidthDownBytes} down {bandwidthUpBytes} up";
        format-ethernet = "E: {ipaddr} {bandwidthDownBytes} down {bandwidthUpBytes} up";
        format-disconnected = "NET: down";
        tooltip-format = "{ifname} · {essid} · {ipaddr}\n{signalStrength}%";
        tooltip-format-disconnected = "No connection";
      };

      # Real internet check (the network module only reports link state).
      "custom/online" = {
        exec = "${pkgs.iputils}/bin/ping -c1 -W2 1.1.1.1 >/dev/null && echo 'NET: up' || echo 'NET: no internet'";
        interval = 10;
        tooltip = false;
      };

      cpu = {
        interval = 2;
        format = "CPU: {usage}%";
        states.warning = 80;
      };

      memory = {
        interval = 5;
        format = "RAM: {used:0.1f}G/{total:0.1f}G";
        tooltip-format = "{percentage}% used";
        states.warning = 80;
      };

      pulseaudio = {
        format = "VOL: {volume}%";
        format-muted = "VOL: muted";
      };

      battery = {
        format = "BAT: {capacity}%";
        states = { warning = 30; critical = 15; };
        format-charging = "CHR: {capacity}%";
        format-plugged = "BAT: full";
        tooltip-format = "{timeTo}";
      };
    };
    style = ''
      * { font-family: "JetBrainsMono Nerd Font"; font-size: 12pt; }
      /* Colors from vague.nvim's palette (lua/vague/config/internal.lua). */
      window#waybar { background: #141415; color: #cdcdcd; }
      #workspaces button { padding: 0 8px; margin: 0; min-width: 0; color: #606079; border-radius: 0; }
      #workspaces button.focused { background: #252530; color: #aeaed1; }
      #workspaces button.urgent { background: #d8647e; color: #141415; }
      /* i3status-style: plain text blocks split by thin pipes */
      #custom-online, #network, #cpu, #memory, #pulseaudio, #battery, #clock, #tray {
        padding: 0 10px; margin: 0; min-width: 0;
        border-left: 1px solid #333738;
      }
      #custom-online { color: #7fa563; }
      #network { color: #cdcdcd; }
      #network.disconnected { color: #d8647e; }
      #cpu { color: #aeaed1; }
      #cpu.warning, #memory.warning, #battery.warning { color: #f3be7c; }
      #memory { color: #aeaed1; }
      #pulseaudio { color: #cdcdcd; }
      #pulseaudio.muted { color: #606079; }
      #battery.charging { color: #7fa563; }
      #battery.critical:not(.charging) { color: #d8647e; }
      #clock { color: #cdcdcd; }
  '';
  };

  # home.file.".local/share/nvim/site/pack/harnessd/start/harnessd".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/dev/harnessd/integrations/nvim";
}
