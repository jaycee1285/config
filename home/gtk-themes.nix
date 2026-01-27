{ config, pkgs, gtk-themes, ... }:

{
  home.packages = [
    gtk-themes.packages.x86_64-linux.catppuccin-gtk-theme
    gtk-themes.packages.x86_64-linux.gruvbox-gtk-theme
    gtk-themes.packages.x86_64-linux.everforest-gtk-theme
    gtk-themes.packages.x86_64-linux.tokyonight-gtk-theme
    gtk-themes.packages.x86_64-linux.osaka-gtk-theme
    gtk-themes.packages.x86_64-linux.kanagawa-gtk-theme
    gtk-themes.packages.x86_64-linux.nordfox-gtk-theme
    gtk-themes.packages.x86_64-linux.orchis-orange-compact
    gtk-themes.packages.x86_64-linux.nordic-polar-gtk-theme
    gtk-themes.packages.x86_64-linux.juno-mirage-gtk-theme
    gtk-themes.packages.x86_64-linux.rose-pine-gtk-theme
    gtk-themes.packages.x86_64-linux.flexoki-gtk-theme
  ];
}
