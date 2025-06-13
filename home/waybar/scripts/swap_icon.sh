#!/usr/bin/env -S bash -euo pipefail

swap=$(free | awk '/Swap:/ {if ($2==0) print 0; else print int($3/$2 * 100)}')

if [ "$swap" -lt 50 ]; then
  icon=""
  class="swap_low"
elif [ "$swap" -lt 75 ]; then
  icon=""
  class="swap_medium"
else
  icon="󰛃"
  class="swap_high"
fi

echo "{\"text\": \"$icon\", \"tooltip\": \"SWAP Usage: $swap%\", \"class\": \"$class\"}"
