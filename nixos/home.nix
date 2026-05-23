{ config, pkgs, ... }: {
  home.username = "e";
  home.homeDirectory = "/home/e";

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

  home.stateVersion = "25.11";

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nix btw";
    };
  };
}
