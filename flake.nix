{
  description = "My NixOS system with GTK themes and super-productivity flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    gtk-themes.url = "path:./gtk-themes";
  inputs.ob-themes.url = "path:./ob-themes";

#    super-productivity.url = "path:./super-productivity";
    home-manager.url = "github:nix-community/home-manager";  # <-- Add this!
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, gtk-themes, ob-themes, home-manager, ... }: {
    nixosConfigurations = {
      john = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          # Enable Home Manager as a NixOS module
          home-manager.nixosModules.home-manager

          # Optionally, you can move gtk.nix contents into home.nix, 
          # or import here as an extra home-manager.users.john = import ./home.nix;
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Set the user (change "john" to your actual username if different)
            home-manager.users.john = import ./home/home.nix;
          }
        ];
        specialArgs = { inherit gtk-themes ob-themes nixpkgs-unstable; };
      };
    };
  };
}
