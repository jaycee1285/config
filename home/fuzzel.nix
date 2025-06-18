{ config, pkgs, ... }:

home.file.".config/fuzzel" = {
  source = ./config/fuzzel;
  target = ".config/fuzzel";
  recursive = true;
  onChange = "true"; # always update
}
