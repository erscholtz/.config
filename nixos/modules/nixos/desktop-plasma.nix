{ pkgs, ... }:

{
  imports = [ ./keyboard.nix ];

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  programs.sway.enable = true;
  # Default extraPackages minus foot (ghostty is the terminal).
  programs.sway.extraPackages = with pkgs; [ brightnessctl grim swayidle swaylock wmenu ];

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
}
