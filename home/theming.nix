{ pkgs, ... }:
{
  home.packages = with pkgs; [
    graphite-cursors
    gruvbox-plus-icons
  ];
}
