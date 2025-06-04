{
  description = "My NixOS system with GTK themes and super-productivity flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    gtk-themes.url = "path:./gtk-themes";
    super-productivity.url = "path:./super-productivity";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, gtk-themes, super-productivity, ... }: {
    nixosConfigurations = {
      john = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
        specialArgs = { inherit gtk-themes nixpkgs-unstable super-productivity; };  # <--- Added here!
      };
    };
  };
}
