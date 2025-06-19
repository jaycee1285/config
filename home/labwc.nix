{ config, pkgs, ... }:
{
  
home.file.".config/labwc" = {
  source = ./labwc;
  target = ".config/labwc";
  recursive = true;
  onChange = "true"; # always update
};

}