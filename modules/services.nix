{ config, pkgs, ... }:

{
  services.printing.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.onedrive.enable = true;
  services.flatpak.enable = true;
  xdg.portal.wlr.enable = true;
  services.system-config-printer.enable = true;
  services.syncthing.enable = true;
  services.blueman.enable = true;
  services.dbus.enable = true;
}
