{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/workstation.nix
    ../../modules/nixos/desktop-sway.nix
  ];

  networking.hostName = "thinkpad";
}
