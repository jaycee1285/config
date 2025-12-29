#!/usr/bin/env bash

get_icon() {
  local perc="$1"
  if   [ "$perc" -lt 50 ]; then
    echo -ne "\uf067"    # plus
  elif [ "$perc" -lt 75 ]; then
    echo -ne "󰍛"    # plus-circle
  else
    echo -ne "\uf0fe"    # plus-square
  fi
}

mem_perc=$(free | awk '/Mem:/ {printf "%d", $3*100/$2}')
swap_perc=$(free | awk '/Swap:/ {if ($2==0) {print 0} else {printf "%d", $3*100/$2}}')

mem_icon=$(get_icon "$mem_perc")
swap_icon=$(get_icon "$swap_perc")

# Output the icons only, separated by a vertical bar
printf "|%s|%s" "$mem_icon" "$swap_icon"
