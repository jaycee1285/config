{ config, pkgs, ... }:

{
  #### Desktop / UX helpers
  services.tumbler.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;

  #### Printing
  services.printing.enable = true;
  services.system-config-printer.enable = true;

  #### Flatpak + portals (LabWC / wlroots)
  services.flatpak.enable = true;
  xdg.portal.wlr.enable = true;

  #### Sync / networking
  services.syncthing.enable = true;
  services.onedrive.enable = false;

  #### Bluetooth
  services.blueman.enable = true;

  #### Power management
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0  = 80;
    };
  };

  #### DNS / resolver
  services.resolved.enable = false;
  networking.resolvconf.enable = true;

  # NOTE:
  # You almost never need this explicitly; NixOS enables dbus when needed.
  # If you want to keep it, it's harmless:
  # services.dbus.enable = true;
  
    qt.enable = true;
  qt.platformTheme = "gnome";   # uses qgnomeplatform
  qt.style = "adwaita-dark";    # or "adwaita"
}
