#!/usr/bin/env bash
set -euo pipefail

# Single-letter mode switch for fuzzel
# B bookmarks, C clipboard, S search, F files, P power, Z normal apps

raw="$(
  printf '' | fuzzel --dmenu --prompt 'Mode (B/C/S/F/P/Z): ' --width 44
)" || exit 0

mode="$(printf '%s' "$raw" | awk '{print toupper($1)}')"

case "$mode" in
  B) exec "$HOME/bin/fz-bookmarks" ;;
  C) exec "$HOME/bin/fz-clip" ;;
  S) exec "$HOME/bin/fz-search" ;;
  F) exec "$HOME/bin/fz-files" ;;
  P) exec "$HOME/bin/fz-power" ;;
  Z) exec fuzzel ;;
  *) exit 0 ;;
esac
