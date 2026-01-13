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

  # rclone available system-wide
  environment.systemPackages = [ pkgs.rclone ];
  systemd.tmpfiles.rules = [
    "d /home/john/pCloud 0755 john users -"
    "d /home/john/.cache/rclone-bisync/pcloud 0700 john users -"
  ];

  systemd.user.services.pcloud-bisync = {
    description = "rclone bisync pCloud <-> /home/john/pCloud";
    wants = [ "network-online.target" ];
    after  = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      RuntimeMaxSec = "12h";

      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/pCloud %h/.cache/rclone-bisync/pcloud";

      ExecStart = ''
        ${pkgs.rclone}/bin/rclone bisync pcloud: %h/pCloud \
          --workdir %h/.cache/rclone-bisync/pcloud \
          --create-empty-src-dirs \
          --exclude "*.partial" \
          --tpslimit 5 --tpslimit-burst 5 \
          --retries 10 --retries-sleep 30s --low-level-retries 50 \
          --stats 30s \
          -vv \
          --log-file %h/.cache/rclone-bisync/pcloud/bisync.log
      '';
    };
  };

  systemd.user.timers.pcloud-bisync = {
    description = "Schedule rclone bisync pCloud";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "10m";
      OnUnitActiveSec = "1h";
      RandomizedDelaySec = "5m";
      Persistent = true;
      Unit = "pcloud-bisync.service";
    };
  };


  #### DNS / resolver
  services.resolved.enable = false;
  networking.resolvconf.enable = true;

  # NOTE:
  # You almost never need this explicitly; NixOS enables dbus when needed.
  # If you want to keep it, it's harmless:
  # services.dbus.enable = true;
}
