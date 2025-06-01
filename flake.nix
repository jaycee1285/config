{
  description = "My NixOS system with GTK themes flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gtk-themes.url = "path:./gtk-theme";
  };

  outputs = { self, nixpkgs, gtk-themes, ... }: {
    nixosConfigurations = {
      myhostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          {
            environment.systemPackages = [
    gtk-themes.packages.x86_64-linux.catppuccin-gtk-theme
    gtk-themes.packages.x86_64-linux.gruvbox-gtk-theme
    gtk-themes.packages.x86_64-linux.everforest-gtk-theme
    gtk-themes.packages.x86_64-linux.tokyonight-gtk-theme
    gtk-themes.packages.x86_64-linux.osaka-gtk-theme
    gtk-themes.packages.x86_64-linux.kanagawa-gtk-theme
    gtk-themes.packages.x86_64-linux.orchis-orange-compact
    gtk-themes.packages.x86_64-linux.nordic-polar-gtk-theme
    gtk-themes.packages.x86_64-linux.juno-gtk-theme
            ];
          }
        ];
      };
    };
  };
}
