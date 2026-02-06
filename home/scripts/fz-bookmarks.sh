#!/usr/bin/env bash
set -euo pipefail

PROFILE_DIR="${PROFILE_DIR:-$HOME/.librewolf}"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/fz-bookmarks.tsv"
TTL_SECONDS=300

PLACES_DB="${PLACES_DB:-$(find "$PROFILE_DIR" -maxdepth 2 -name places.sqlite -print -quit)}"
[ -n "${PLACES_DB:-}" ] || exit 0

refresh_cache() {
  local tmp db_copy
  tmp="$(mktemp)"
  db_copy="$(mktemp)"
  cp -f "$PLACES_DB" "$db_copy"

  sqlite3 -readonly "$db_copy" <<'SQL' >"$tmp"
.mode tabs
.headers off
SELECT
  REPLACE(IFNULL(b.title, p.title), char(9), ' ') AS title,
  p.url AS url
FROM moz_bookmarks b
JOIN moz_places p ON b.fk = p.id
WHERE b.type = 1 AND p.url LIKE 'http%'
ORDER BY b.dateAdded DESC;
SQL

  rm -f "$db_copy"
  mv -f "$tmp" "$CACHE"
}

needs_refresh=true
if [[ -f "$CACHE" ]]; then
  now="$(date +%s)"
  mtime="$(stat -c %Y "$CACHE" 2>/dev/null || echo 0)"
  (( now - mtime < TTL_SECONDS )) && needs_refresh=false
fi
$needs_refresh && refresh_cache

choice="$(
  awk -F'\t' 'NF>=2 {printf "%s\t%s\n", $1, $2}' "$CACHE" \
  | fuzzel --dmenu --prompt 'Bookmarks: ' --width 110
)" || exit 0

url="$(printf '%s' "$choice" | awk -F'\t' '{print $2}')"
[[ -n "${url:-}" ]] && librewolf "$url" >/dev/null 2>&1 &
