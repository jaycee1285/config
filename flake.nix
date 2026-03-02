{
  description = "My NixOS system with GTK themes and super-productivity flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-labwc-092.url = "github:NixOS/nixpkgs/00c21e4c93d963c50d4c0c89bfa84ed6e0694df2";
    gtk-themes.url = "path:./gtk-themes";
    ob-themes.url = "path:./ob-themes";
    home-manager.url = "github:nix-community/home-manager";
    helium-nix.url = "git+https://codeberg.org/MachsteNix/helium-nix";
    crustdown.url = "github:jaycee1285/crustdown";
    crustdown.inputs.nixpkgs.follows = "nixpkgs";
    krust.url = "github:jaycee1285/krust";
    krust.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    walls.url = "github:jaycee1285/walls";
    base16changer.url = "github:jaycee1285/base16changer";
    ferritebar.url = "github:jaycee1285/ferritebar";
    ferritebar.inputs.nixpkgs.follows = "nixpkgs";
    sartwc.url = "path:/home/john/repos/sartwc";
    sartwc.inputs.nixpkgs.follows = "nixpkgs";
    intentile.url = "path:/home/john/repos/intentile";
    intentile.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-labwc-092, gtk-themes, ob-themes, home-manager, helium-nix, crustdown, krust, nix-vscode-extensions, walls, base16changer, ferritebar, sartwc, intentile, ... }:
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

      obThemesPkg = ob-themes.packages.${system}.default;

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
              inherit gtk-themes nixpkgs-unstable crustdown krust nix-vscode-extensions walls base16changer ferritebar helium-nix sartwc intentile;
              ob-themes = obThemesPkg;
            };
          }
        ];
        specialArgs = {
          inherit nixpkgs-unstable helium-nix sartwc intentile;
          ob-themes = obThemesPkg;
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
            inherit helium-nix;
          };
        };
      };
    };
}
