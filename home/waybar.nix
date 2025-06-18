{ config, pkgs, ... }:

home.file.".config/waybar" = {
  source = ./config/waybar;
  target = ".config/waybar";
  recursive = true;
  onChange = "true"; # always update
}
