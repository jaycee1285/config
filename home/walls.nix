{ pkgs, walls, ... }:

let
  wallsPackage = walls.packages.${pkgs.system}.default;
in {
  home.file."Pictures/walls" = {
    source = "${wallsPackage}/share/wallpapers";
    recursive = true;
  };
}
