{ config, pkgs, lib, ... }:

let
  pcloudBisync = pkgs.writeShellScript "pcloud-bisync" ''
    set -euo pipefail
    ${pkgs.coreutils}/bin/mkdir -p "$HOME/pCloud" "$HOME/.cache/rclone-bisync/pcloud"

    notify() {
      ${pkgs.libnotify}/bin/notify-send \
        --app-name="pCloud Sync" \
        --urgency="$1" \
        "pCloud Sync" "$2" || true
    }

    if ! ${pkgs.rclone}/bin/rclone lsd pcloud: >/dev/null; then
      notify critical "Sync skipped: pCloud remote is not listable"
      exit 7
    fi

    set +e
    ${pkgs.rclone}/bin/rclone bisync pcloud: "$HOME/pCloud" \
      --workdir "$HOME/.cache/rclone-bisync/pcloud" \
      --size-only \
      --create-empty-src-dirs \
      --exclude "*.part" \
      --exclude "*.partial" \
      --exclude ".Trash-1000/**" \
      --exclude "**/.Trash-1000/**" \
      --exclude "**/node_modules/**" \
      --tpslimit 10 --tpslimit-burst 10 \
      --checkers 32 --transfers 16 \
      --disable ListR \
      --retries 10 --retries-sleep 30s --low-level-retries 50 \
      --stats 30s -v
    rc=$?
    set -e

    if [ "$rc" -eq 0 ]; then
      notify low "Sync completed successfully"
    else
      notify critical "Sync failed (exit code $rc)"
    fi

    exit "$rc"
  '';
in
{
  home.packages = with pkgs; [
    syncthing
    pkgs.unstable.pcloud
    rclone
  ];

  systemd.user.services.pcloud-bisync = {
    Unit = {
      Description = "rclone bisync pCloud <-> /home/john/pCloud (every 2h)";
      Wants = "network-online.target";
      After = "network-online.target";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${pcloudBisync}";
    };
  };

  systemd.user.timers.pcloud-bisync = {
    Unit = {
      Description = "Timer: rclone bisync pCloud every 2 hours";
    };
    Timer = {
      OnBootSec = "10m";
      OnUnitActiveSec = "2h";
      RandomizedDelaySec = "5m";
      Persistent = true;
      Unit = "pcloud-bisync.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
