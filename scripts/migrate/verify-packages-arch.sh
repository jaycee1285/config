#!/usr/bin/env bash
set -euo pipefail

LIST=${1:-/home/john/repos/config/scripts/migrate/package-list.txt}

missing=()

while IFS= read -r line; do
  line="${line%%#*}"
  line="$(echo "$line" | xargs)"
  [ -z "$line" ] && continue
  pkg="$line"
  if pacman -Si "$pkg" >/dev/null 2>&1; then
    echo "OK   $pkg"
  else
    echo "MISS $pkg"
    missing+=("$pkg")
  fi
done < "$LIST"

if [ ${#missing[@]} -gt 0 ]; then
  echo ""
  echo "Missing packages (${#missing[@]}):"
  printf '%s\n' "${missing[@]}"
  echo ""
  echo "Nix fallback commands:"
  for m in "${missing[@]}"; do
    echo "nix profile install nixpkgs#${m}"
  done
else
  echo ""
  echo "All packages found in Arch repos."
fi
