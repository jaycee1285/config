#!/usr/bin/env bash
set -euo pipefail

# Single-letter mode switch for fuzzel
# B bookmarks, C clipboard, S search, F files, P power, Z normal apps

raw="$(
  printf '' | fuzzel --dmenu --prompt 'Mode (B bookmarks, C clipboard, S search, F files, P power, Z normal): ' --width 90
)" || exit 0

mode="$(printf '%s' "$raw" | awk '{print toupper($1)}')"

case "$mode" in
  B) exec "$HOME/.local/bin/fz-bookmarks" ;;
  C) exec "$HOME/.local/bin/fz-clip" ;;
  S) exec "$HOME/.local/bin/fz-search" ;;
  F) exec "$HOME/.local/bin/fz-files" ;;
  P) exec "$HOME/.local/bin/fz-power" ;;
  Z) exec fuzzel ;;
  *) exit 0 ;;
esac
