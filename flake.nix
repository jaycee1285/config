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
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, gtk-themes, ob-themes, home-manager, labwcchanger, zen-browser, claude-desktop, helium-nix, ... }:
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
        # Add labwcchanger overlay
        (final: prev: {
          labwcchanger = labwcchanger.packages.${system}.default;
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
        john = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = ".bakbuk";
              home-manager.users.john = import ./home/home.nix;

              home-manager.extraSpecialArgs = {
                inherit pkgs gtk-themes nixpkgs-unstable;
                ob-themes = obThemesPkg;
              };
            }
          ];
          specialArgs = {
            inherit pkgs gtk-themes nixpkgs-unstable claude-desktop zen-browser helium-nix;
            ob-themes = obThemesPkg;
            # Remove labwcchanger from here since it's now in the overlay
          };
        };
      };
    };
}