{
  description = "My NixOS system with GTK themes and super-productivity flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    gtk-themes.url = "path:./gtk-themes";
    ob-themes.url = "path:./ob-themes";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, gtk-themes, nur, ob-themes, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nur.overlay ];
      };
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
            }
          ];
          specialArgs = {
            inherit pkgs nur gtk-themes ob-themes nixpkgs-unstable;
          };
        };
      };
    };
}
