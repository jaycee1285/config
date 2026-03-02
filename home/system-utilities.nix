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
    lxqt.pcmanfm-qt

    # Disk tools
    qdirstat
    czkawka-full
    gparted

    # Utilities
    bleachbit
    collector
    bazaar
    peazip

    # Boot media
    usbimager

    # Backup
    kopia-ui
    themechanger
  ];
}
