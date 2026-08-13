{ config, pkgs, herdr, ... }: {
  home.stateVersion = "25.11";
  home.username = "e";
  home.homeDirectory = "/home/e";
  xdg.enable = true;

  home.sessionVariables = {
    PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi";
  };

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

  # home.file.".local/share/nvim/site/pack/harnessd/start/harnessd".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/dev/harnessd/integrations/nvim";
}
