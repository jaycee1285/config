{ config, pkgs, ... }:

home.file.".config/labwc" = {
  source = ./config/labwc;
  target = ".config/labwc";
  recursive = true;
  onChange = "true"; # always update
};

