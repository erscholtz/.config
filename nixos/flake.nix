{
  description = "super basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    t3code = {
      url = "github:Sawrz/t3code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium.url = "github:FKouhai/helium2nix/main";

    zig-overlay.url = "github:mitchellh/zig-overlay";

#    harnessd = {
#      url = "path:/home/e/Documents/dev/harnessd";
#      inputs.nixpkgs.follows = "nixpkgs-unstable";
#    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, t3code, helium, zig-overlay, ... }: {
    nixosConfigurations.thinkbox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
	inherit nixpkgs-unstable t3code helium zig-overlay;
      };

      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.e = import ./home.nix;

            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
