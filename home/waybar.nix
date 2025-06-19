{ config, pkgs, ... }:
{
home.file.".config/waybar" = {
  source = ./waybar;
  target = ".config/waybar";
  recursive = true;
  onChange = "true"; # always update
};
}