{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/workstation.nix
  ];

  networking.hostName = "thinkpad";
}
