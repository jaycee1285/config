{ config, pkgs, lib, ... }:

let
  pcloudBisync = pkgs.writeShellScript "pcloud-bisync" ''
    set -euo pipefail
    mkdir -p "$HOME/pCloud" "$HOME/.cache/rclone-bisync/pcloud"

    exec ${pkgs.rclone}/bin/rclone bisync pcloud: "$HOME/pCloud" \
      --workdir "$HOME/.cache/rclone-bisync/pcloud" \
      --size-only \
      --create-empty-src-dirs \
      --exclude "*.partial" \
      --exclude ".Trash-1000/**" \
      --exclude "**/.Trash-1000/**" \
      --exclude "**/node_modules/**" \
      --tpslimit 10 --tpslimit-burst 10 \
      --checkers 32 --transfers 16 \
      --fast-list \
      --retries 10 --retries-sleep 30s --low-level-retries 50 \
      --stats 30s -v
  '';
in
{
  environment.systemPackages = [ pkgs.rclone ];

  systemd.user.services.pcloud-bisync = {
    description = "rclone bisync pCloud <-> /home/john/pCloud (every 2h)";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pcloudBisync}";
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
