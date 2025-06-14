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

      # Stable and unstable pkgs
      pkgs = import nixpkgs { inherit system; };
      unstable = import nixpkgs-unstable { inherit system; };

      # Precomputed Openbox theme derivation
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
              home-manager.backupFileExtension = "backup";

              home-manager.users.john = import ./home/home.nix;

              home-manager.extraSpecialArgs = {
                inherit pkgs unstable gtk-themes;
                ob-themes = obThemesPkg;
              };
            }
          ];

          specialArgs = {
            inherit pkgs unstable gtk-themes;
            ob-themes = obThemesPkg;
          };
        };
      };
    };
}
