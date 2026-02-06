#!/usr/bin/env bash
set -euo pipefail

choice="$(
  cliphist list | fuzzel --dmenu --prompt 'Clipboard: ' --width 90
)" || exit 0

printf '%s' "$choice" | cliphist decode | wl-copy
