{ config, pkgs, unstable, labwcchanger-tui, ... }:
{
  home.packages = [
    labwcchanger-tui.packages.${pkgs.system}.default
    pkgs.heroic
    pkgs.rclone-ui
    pkgs.unstable.pixieditor
    pkgs.rclone
  ];
}
