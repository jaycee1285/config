{ config, pkgs, ... }:

{
  services.printing.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.onedrive.enable = false;
  services.power-profiles-daemon.enable = false;
  services.flatpak.enable = true;
  xdg.portal.wlr.enable = true;
  services.system-config-printer.enable = true;
  services.syncthing.enable = true;
  services.blueman.enable = true;
  services.dbus.enable = true;
  services.tlp.enable = true;
services.tlp.settings = {
  START_CHARGE_THRESH_BAT0 = 75;
  STOP_CHARGE_THRESH_BAT0 = 80;
};
services.resolved.enable = false;
  networking.resolvconf.enable = true;   # provide a working /sbin/resolvconf
}
