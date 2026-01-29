{
  description = "My NixOS system with GTK themes and super-productivity flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    gtk-themes.url = "path:./gtk-themes";
    ob-themes.url = "path:./ob-themes";
    home-manager.url = "github:nix-community/home-manager";
    labwcchanger.url = "github:jaycee1285/labwcchanger";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    helium-nix.url = "git+https://codeberg.org/MachsteNix/helium-nix";
    labwcchanger-tui.url = "github:jaycee1285/labwcchanger-tui";
    labwcchanger-tui.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    walls.url = "github:jaycee1285/walls";
    spredux.url = "git+file:///home/john/repos/SPRedux";
    coverpro.url = "git+file:///home/john/repos/coverpro";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, gtk-themes, ob-themes, home-manager, labwcchanger, zen-browser, claude-desktop, helium-nix, labwcchanger-tui, nix-vscode-extensions, walls, spredux, coverpro, ... }:
    let
      system = "x86_64-linux";

      overlays = [
        # Define `unstable` overlay
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
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

    in {
      nixosConfigurations = {
        # Host: Sed
        Sed = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/Sed
            { nixpkgs.overlays = overlays; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = ".bakbuk";
              home-manager.users.john = import ./home/home.nix;

              home-manager.extraSpecialArgs = {
                inherit pkgs gtk-themes nixpkgs-unstable labwcchanger-tui nix-vscode-extensions walls spredux coverpro;
                ob-themes = obThemesPkg;
              };
            }
          ];
          specialArgs = {
            inherit pkgs nixpkgs-unstable claude-desktop zen-browser helium-nix walls;
            ob-themes = obThemesPkg;
          };
        };

        # Host: Zed
        Zed = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/Zed
            { nixpkgs.overlays = overlays; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = ".bakbuk";
              home-manager.users.john = import ./home/home.nix;

              home-manager.extraSpecialArgs = {
                inherit pkgs gtk-themes nixpkgs-unstable labwcchanger-tui nix-vscode-extensions walls coverpro;
                ob-themes = obThemesPkg;
              };
            }
          ];
          specialArgs = {
            inherit pkgs nixpkgs-unstable claude-desktop zen-browser helium-nix;
            ob-themes = obThemesPkg;
          };
        };

        # Emergency ISO with LabWC environment
        # Build with: nix build .#nixosConfigurations.iso.config.system.build.isoImage
        iso = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./iso.nix ];
          specialArgs = {
            inherit helium-nix spredux;
          };
        };
      };
    };
}