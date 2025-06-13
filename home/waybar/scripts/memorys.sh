#!/usr/bin/env -S bash -euo pipefail

mem=$(free | awk '/Mem:/ {print int($3/$2 * 100)}')
swap=$(free | awk '/Swap:/ {if ($2==0) print 0; else print int($3/$2 * 100)}')

# Nerd Font icons
ram_icon=""
swap_icon=""

# RAM class
if [ "$mem" -lt 50 ]; then
  mem_class="low"
  ram_icon=""
elif [ "$mem" -lt 75 ]; then
  mem_class="medium"
  ram_icon=""
else
  mem_class="high"
  ram_icon="󰛃"
fi

# SWAP class
if [ "$swap" -lt 50 ]; then
  swap_class="swap_low"
  swap_icon=""
elif [ "$swap" -lt 75 ]; then
  swap_class="swap_medium"
  swap_icon=""
else
  swap_class="swap_high"
  swap_icon="󰛃"
fi

# Final output
text="$ram_icon | $swap_icon"

echo "{\"text\": \"$text\", \"class\": \"$mem_class $swap_class\"}"
