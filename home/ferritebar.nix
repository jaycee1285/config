{ config, pkgs, ferritebar, ... }:
let
  ferritebarRepoDir = "${config.home.homeDirectory}/repos/config/home/ferritebar";
in {
  home.packages = [ ferritebar.packages.${pkgs.system}.default ];

  xdg.configFile."ferritebar".source =
    config.lib.file.mkOutOfStoreSymlink ferritebarRepoDir;
  xdg.configFile."ferritebar".recursive = true;
}
