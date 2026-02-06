#!/usr/bin/env bash
set -euo pipefail

lock_cmd="${LOCK_CMD:-swaylock -f}"

choice="$(
  printf '%s\n' Lock Logout Suspend Reboot Shutdown \
  | fuzzel --dmenu --prompt 'Power: ' --width 30
)" || exit 0

case "$choice" in
  Lock)     sh -lc "$lock_cmd" ;;
  Logout)   loginctl terminate-user "$USER" ;;
  Suspend)  systemctl suspend ;;
  Reboot)   systemctl reboot ;;
  Shutdown) systemctl poweroff ;;
  *)        exit 0 ;;
esac
