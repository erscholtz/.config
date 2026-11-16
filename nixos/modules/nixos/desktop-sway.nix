{ pkgs, ... }:

# Sway-only desktop: no X11 desktop environments, no Plasma/XFCE sessions.
# greetd + tuigreet launches sway directly, so it is the only session.
{
  imports = [ ./keyboard.nix ];

  programs.sway.enable = true;
  # Default extraPackages minus foot (ghostty is the terminal).
  programs.sway.extraPackages = with pkgs; [ brightnessctl grim swayidle swaylock wmenu ];

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
      user = "greeter";
    };
  };
}
