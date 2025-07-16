{ config, pkgs, ... }:
let
  # Absolute path to the directory you edit in Git
  labwcRepoDir = "${config.home.homeDirectory}/repos/config/home/labwc";
in {
  # Either style works; pick one and keep it consistent
  # (1) The newer xdg-aware way …
  xdg.configFile."labwc".source =
    config.lib.file.mkOutOfStoreSymlink labwcRepoDir;
  xdg.configFile."labwc".recursive = true;
}


