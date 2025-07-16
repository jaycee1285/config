{ config, pkgs, ... }:
let
  # Absolute path to the directory you edit in Git
  waybarRepoDir = "${config.home.homeDirectory}/repos/config/home/waybar";
in {
  # Either style works; pick one and keep it consistent
  # (1) The newer xdg-aware way …
  xdg.configFile."waybar".source =
    config.lib.file.mkOutOfStoreSymlink waybarRepoDir;
  xdg.configFile."waybar".recursive = true;
}


