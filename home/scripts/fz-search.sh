#!/usr/bin/env bash
set -euo pipefail

q="$(
  printf '' | fuzzel --dmenu --prompt 'Search: ' --width 70
)" || exit 0

q="${q#"${q%%[![:space:]]*}"}"
q="${q%"${q##*[![:space:]]}"}"
[[ -z "$q" ]] && exit 0

zen --search "$q" >/dev/null 2>&1 &
