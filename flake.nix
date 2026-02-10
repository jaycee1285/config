{
  description = "My NixOS system with GTK themes and super-productivity flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    gtk-themes.url = "path:./gtk-themes";
    ob-themes.url = "path:./ob-themes";
    home-manager.url = "github:nix-community/home-manager";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    helium-nix.url = "git+https://codeberg.org/MachsteNix/helium-nix";
    crustdown.url = "github:jaycee1285/crustdown";
    crustdown.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    walls.url = "github:jaycee1285/walls";
    base16changer.url = "github:jaycee1285/base16changer";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, gtk-themes, ob-themes, home-manager, zen-browser, claude-desktop, helium-nix, crustdown, nix-vscode-extensions, walls, base16changer, ... }:
    let
      system = "x86_64-linux";

      overlays = [
        # Define `unstable` overlay
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "librewolf-bin-147.0.1-3"
              ];
            };
          };
        })
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      obThemesPkg = ob-themes.packages.${system}.default;

      # Shared host configuration - all hosts are identical except hostname/hardware
      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/${hostname}
          { nixpkgs.overlays = overlays; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = ".bakbuk";
            home-manager.users.john = import ./home/home.nix;

            home-manager.extraSpecialArgs = {
              inherit pkgs gtk-themes nixpkgs-unstable crustdown nix-vscode-extensions walls base16changer;
              ob-themes = obThemesPkg;
            };
          }
        ];
        specialArgs = {
          inherit pkgs nixpkgs-unstable claude-desktop zen-browser helium-nix;
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
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./iso.nix
          ];
          specialArgs = {
            inherit helium-nix;
          };
        };
      };
    };
}