{ config, pkgs, ... }:
let
  makoRepoDir = "${config.home.homeDirectory}/repos/config/home/mako";
in {
  xdg.configFile."mako".source =
    config.lib.file.mkOutOfStoreSymlink makoRepoDir;
  xdg.configFile."mako".recursive = true;
}
