{ config, pkgs, ... }:

let
  configDir = ./labwc;
in {
  home.file.".config/labwc".source = configDir;
}
