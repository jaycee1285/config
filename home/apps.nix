{ config, pkgs, unstable, labwcchanger-tui, ... }:
{
  home.packages = [
    labwcchanger-tui.packages.${pkgs.system}.default
    pkgs.heroic
    pkgs.rclone-ui
    pkgs.unstable.pixieditor
    pkgs.rclone
    pkgs.keychron-udev-rules
    pkgs.material-design-icons
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.kio
    pkgs.kdePackages.kio-extras
  ];
}
