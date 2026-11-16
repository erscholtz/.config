{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/workstation.nix
    ../../modules/nixos/desktop-plasma.nix
  ];

  networking.hostName = "thinkbox";
}
