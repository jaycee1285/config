{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.rclone ];

  # Ensure local mirror + workdir exist (idempotent)
  systemd.tmpfiles.rules = [
    "d /home/john/pCloud 0755 john users -"
    "d /home/john/.cache/rclone-bisync/pcloud 0700 john users -"
  ];

  systemd.user.services.pcloud-bisync = {
    description = "rclone bisync pCloud <-> /home/john/pCloud (every 2h)";
    wants = [ "network-online.target" ];
    after  = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      RuntimeMaxSec = "6h";

      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/pCloud %h/.cache/rclone-bisync/pcloud";

      ExecStart = ''
        ${pkgs.rclone}/bin/rclone bisync pcloud: %h/pCloud \
          --workdir %h/.cache/rclone-bisync/pcloud \
          --create-empty-src-dirs \
          --exclude "*.partial" \
          --exclude ".Trash-1000/**" \
          --exclude "**/.Trash-1000/**" \
          --exclude "**/node_modules/**" \
          --tpslimit 10 --tpslimit-burst 10 \
          --checkers 32 --transfers 16 \
          --fast-list \
          --no-update-modtime \
          --no-update-dir-modtime \
          --retries 10 --retries-sleep 30s --low-level-retries 50 \
          --stats 30s \
          -v
      '';
    };
  };

  systemd.user.timers.pcloud-bisync = {
    description = "Timer: rclone bisync pCloud every 2 hours";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "10m";
      OnUnitActiveSec = "2h";
      RandomizedDelaySec = "5m";
      Persistent = true;
      Unit = "pcloud-bisync.service";
    };
  };
}
