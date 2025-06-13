{ config, pkgs, ... }:

let
  configDir = ./waybar;
in {
  home.file.".config/waybar".source = configDir;
}
