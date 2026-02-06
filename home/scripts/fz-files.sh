#!/usr/bin/env bash
set -euo pipefail

# Step 1: pick scope dir (editable)
scope="$(
  printf '%s\n' \
    "$HOME" \
    "$HOME/repos" \
    "$HOME/Downloads" \
    "$HOME/Documents" \
  | fuzzel --dmenu --prompt 'Scope dir: ' --width 90
)" || exit 0

# expand ~ if user typed it
[[ "$scope" == "~"* ]] && scope="${scope/#\~/$HOME}"
[[ -d "$scope" ]] || exit 0

# Step 2: query string
q="$(
  printf '' | fuzzel --dmenu --prompt "Find in $(basename "$scope"): " --width 70
)" || exit 0

# build file list (scoped)
mapfile -t files < <(
  rg --files "$scope" \
    --hidden --follow \
    -g '!.git/' \
    -g '!node_modules/' \
    -g '!.direnv/' \
    -g '!result/' \
    -g '!dist/' \
    -g '!build/' \
    -g '!target/' \
  || true
)

# optional AND filter by words (fast + simple)
if [[ -n "${q// /}" ]]; then
  for w in $q; do
    mapfile -t files < <(printf '%s\n' "${files[@]}" | grep -iF -- "$w" || true)
  done
fi

file="$(
  printf '%s\n' "${files[@]}" \
  | fuzzel --dmenu --prompt "Files: " --width 110
)" || exit 0

[[ -n "$file" ]] || exit 0

if [[ -n "${EDITOR:-}" ]]; then
  "$EDITOR" "$file" &
else
  xdg-open "$file" >/dev/null 2>&1 &
fi
