{ pkgs, ... }:

{
  users.users.e = {
    isNormalUser = true;
    description = "e";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.dolphin
      kdePackages.okular
      kdePackages.ark
      kdePackages.spectacle
    ];
  };
}
