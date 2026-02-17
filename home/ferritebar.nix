{ config, pkgs, ... }:
let
  apps = import ../tauri.nix { inherit pkgs; };
  ferritebarRepoDir = "${config.home.homeDirectory}/repos/config/home/ferritebar";
in {
  home.packages = [ apps.ferritebar ];

  xdg.configFile."ferritebar".source =
    config.lib.file.mkOutOfStoreSymlink ferritebarRepoDir;
  xdg.configFile."ferritebar".recursive = true;
}
