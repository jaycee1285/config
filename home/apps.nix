{ config, pkgs, unstable, labwcchanger-tui, ... }:
{
  home.packages = with pkgs; [
    embellish
    heroic
    keychron-udev-rules
    labwcchanger-tui.packages.${pkgs.system}.default
    material-design-icons
    qalculate-gtk
    rclone
    rclone-ui
    rustc
    pixieditor
    wayvnc
    webkitgtk_6_0
    zoxide
    television
  ];
}
