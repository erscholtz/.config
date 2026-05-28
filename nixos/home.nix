{ config, pkgs, ... }: {
  home.stateVersion = "25.11";
  home.username = "e";
  home.homeDirectory = "/home/e";
  xdg.enable = true;

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "erik";
        email = "erikscholtz23@gmail.com";
      };

      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nix btw";
    };
  };

  programs.tmux = {
    enable = true;
  };

  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/tmux/tmux.conf";

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

  # home.file.".local/share/nvim/site/pack/harnessd/start/harnessd".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/dev/harnessd/integrations/nvim";
}
