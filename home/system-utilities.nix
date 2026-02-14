{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Desktop controls
    pkgs.unstable.blueman
    pavucontrol
    brightnessctl
    networkmanagerapplet

    # Display management
    wdisplays
    wlr-randr
    wl-gammactl

    # File management
    thunar-volman
    thunar-archive-plugin
    xarchiver

    # Disk tools
    qdirstat
    czkawka-full
    fclones-gui
    gparted

    # Utilities
    bleachbit
    collector
    bazaar
    peazip

    # Boot media
    usbimager
    unetbootin

    # Backup
    kopia-ui
    themechanger
  ];
}
