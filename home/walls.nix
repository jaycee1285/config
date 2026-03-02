{ pkgs, walls, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  wallsPackage = walls.packages.${system}.default;
in {
  home.file."Pictures/walls" = {
    source = "${wallsPackage}/share/wallpapers";
    recursive = true;
  };
}
