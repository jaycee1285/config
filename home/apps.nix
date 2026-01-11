{ config, pkgs, unstable, labwcchanger-tui, ... }:
{
  home.packages = [
    labwcchanger-tui.packages.${pkgs.system}.default
    pkgs.rustdesk-flutter
    pkgs.rustdesk-server
    pkgs.heroic
    pkgs.rclone-ui
    pkgs.unstable.pixieditor
  ];
}
