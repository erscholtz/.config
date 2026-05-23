{ config, pkgs, ... }: {
  home.username = "e";
  home.homeDirectory = "/home/e";

  programs.git = {
    enable = true;

    settings = {
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
