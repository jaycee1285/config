{ config, pkgs, ... }:

let
  configDir = ./fuzzel;
in {
  home.file.".config/fuzzel".source = configDir;
}
