{
  description = "My NixOS system with GTK themes flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    gtk-themes.url = "path:./gtk-themes";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, gtk-themes, ... }: {
    nixosConfigurations = {
      john = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
        specialArgs = { inherit gtk-themes nixpkgs-unstable; };
      };
    };
  };
}
