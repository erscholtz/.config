# Placeholder hardware config for the thinkpad host.
#
# Replace this on the laptop with:
#
#   sudo nixos-generate-config --show-hardware-config > ~/.config/nixos/hosts/thinkpad/hardware-configuration.nix

{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
