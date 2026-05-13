{
  description = "My NixOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-labwc-092.url = "github:NixOS/nixpkgs/00c21e4c93d963c50d4c0c89bfa84ed6e0694df2";
    home-manager.url = "github:nix-community/home-manager";
    helium-nix.url = "github:schembriaiden/helium-browser-nix-flake";
    walls.url = "github:jaycee1285/walls";
    base16changer.url = "github:jaycee1285/base16changer";
    sartwc.url = "github:jaycee1285/sartwc";
    sartwc.inputs.nixpkgs.follows = "nixpkgs";
    intentile.url = "github:jaycee1285/intentile";
    intentile.inputs.nixpkgs.follows = "nixpkgs";
    openswarm-src = {
      url = "github:jaycee1285/OpenSwarm";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-labwc-092, home-manager, helium-nix, walls, base16changer, sartwc, intentile, openswarm-src, ... }:
    let
      system = "x86_64-linux";
      nixpkgsPolicy = {
        allowUnfree = true;
      };

      overlays = [
        # Define `unstable` overlay
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config = nixpkgsPolicy;
          };
          labwc092 = (import nixpkgs-labwc-092 {
            inherit system;
            config = nixpkgsPolicy;
          }).labwc;
        })
      ];

      # Shared host configuration - all hosts are identical except hostname/hardware
      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/${hostname}
          { nixpkgs.config = nixpkgsPolicy; }
          { nixpkgs.overlays = overlays; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = ".bakbuk";
            home-manager.users.john = import ./home/home.nix;

            home-manager.extraSpecialArgs = {
              inherit nixpkgs-unstable walls base16changer helium-nix sartwc intentile openswarm-src;
            };
          }
        ];
        specialArgs = {
          inherit nixpkgs-unstable helium-nix sartwc intentile openswarm-src;
        };
      };

    in {
      nixosConfigurations = {
        Sed = mkHost "Sed";
        Zed = mkHost "Zed";

        # Emergency ISO with LabWC environment
        # Build with: nix build .#nixosConfigurations.iso.config.system.build.isoImage
        iso = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
            { nixpkgs.config = nixpkgsPolicy; }
            { nixpkgs.overlays = overlays; }
            ./iso.nix
          ];
          specialArgs = {
            inherit helium-nix openswarm-src;
          };
        };
      };
    };
}
