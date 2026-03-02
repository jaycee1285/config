{ config, pkgs, ... }:
let
  labwcRepoDir = "${config.home.homeDirectory}/repos/config/home/labwc";
in {
  xdg.configFile."labwc".source =
    config.lib.file.mkOutOfStoreSymlink labwcRepoDir;
  xdg.configFile."labwc".recursive = true;
}
