{ config, pkgs, ... }:
let
  # Absolute path to the directory you edit in Git
  fuzzelRepoDir = "${config.home.homeDirectory}/repos/config/home/fuzzel";
in {
  # Either style works; pick one and keep it consistent
  # (1) The newer xdg-aware way …
  xdg.configFile."fuzzel".source =
    config.lib.file.mkOutOfStoreSymlink fuzzelRepoDir;
  xdg.configFile."fuzzel".recursive = true;
}


