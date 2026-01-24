{ config, lib, pkgs, walls, ... }:

let
  cfg = config.walls;
  wallsPackage = inputs.walls.packages.${pkgs.system}.default;
in {
  options.walls = {
    enable = lib.mkEnableOption "wallpaper collection";

    directory = lib.mkOption {
      type = lib.types.str;
      default = "Pictures/walls";
      description = "Directory relative to home where wallpapers are stored";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.${cfg.directory} = {
      source = "${wallsPackage}/share/wallpapers";
      recursive = true;
    };
  };
}