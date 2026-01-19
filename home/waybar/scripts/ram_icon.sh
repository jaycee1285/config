#!/usr/bin/env -S bash -euo pipefail

mem=$(free | awk '/Mem:/ {print int($3/$2 * 100)}')

if [ "$mem" -lt 50 ]; then
  icon="󰾆"
  class="low"
elif [ "$mem" -lt 75 ]; then
  icon="󰾅"
  class="medium"
else
  icon="󰓅"
  class="high"
fi

echo "{\"text\": \"$icon\", \"tooltip\": \"RAM Usage: $mem%\", \"class\": \"$class\"}"
