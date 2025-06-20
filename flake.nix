{
  description = "My NixOS system with GTK themes and super-productivity flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    gtk-themes.url = "path:./gtk-themes";
    ob-themes.url = "path:./ob-themes";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, gtk-themes, ob-themes, home-manager, ... }:
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
        config.allowUnfree = true;
        config.android_sdk.accept_license = true;
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
              home-manager.backupFileExtension = ".backup";
              home-manager.users.john = import ./home/home.nix;

              home-manager.extraSpecialArgs = {
                inherit pkgs gtk-themes nixpkgs-unstable;
                ob-themes = obThemesPkg;
              };
            }
          ];
          specialArgs = {
            inherit pkgs gtk-themes nixpkgs-unstable;
            ob-themes = obThemesPkg;
          };
        };
      };
    };
}
