#!/usr/bin/env bash

# Directories to check for GTK themes
THEME_DIRS=(
  "/run/current-system/sw/share/themes"
  "$HOME/.local/share/themes"
)

declare -A THEME_PATHS
themes=()
i=1

echo "Available GTK themes:"

for dir in "${THEME_DIRS[@]}"; do
  [ -d "$dir" ] || continue
  for theme in "$dir"/*; do
    [ -d "$theme" ] || continue
    if [ -f "$theme/gtk-3.0/gtk.css" ]; then
      name="$(basename "$theme")"
      # Prefer user theme if duplicate
      THEME_PATHS["$name"]="$theme"
      # Add to list if not already present
      if [[ ! " ${themes[*]} " =~ " $name " ]]; then
        echo "  [$i] $name (${dir/#$HOME/~})"
        themes+=("$name")
        i=$((i+1))
      fi
    fi
  done
done

if [ ${#themes[@]} -eq 0 ]; then
  echo "No GTK themes with gtk-3.0/gtk.css found."
  exit 1
fi

# Prompt user to pick a theme
read -rp "Enter the number of the theme to sync with fuzzel: " num

if ! [[ "$num" =~ ^[0-9]+$ ]] || [ "$num" -lt 1 ] || [ "$num" -gt ${#themes[@]} ]; then
  echo "Invalid selection."
  exit 1
fi

THEME_NAME="${themes[$((num-1))]}"
GTK_THEME_DIR="${THEME_PATHS[$THEME_NAME]}/gtk-3.0"
FUZZEL_CONFIG="$HOME/.config/fuzzel/fuzzel.ini"

echo "Using theme: $THEME_NAME"

if [ ! -f "$GTK_THEME_DIR/gtk.css" ]; then
  echo "gtk.css not found in $GTK_THEME_DIR"
  exit 1
fi

if [ ! -f "$FUZZEL_CONFIG" ]; then
  echo "Fuzzel config not found: $FUZZEL_CONFIG"
  exit 1
fi

# Helper: Extract color (add 'FF' for alpha)
get_color() {
  local val
  val=$(grep -E "@define-color[[:space:]]+$1[[:space:]]+" "$GTK_THEME_DIR/gtk.css" | head -n1 | awk '{print $3}' | tr -d ';')
  if [[ "$val" =~ ^#([A-Fa-f0-9]{6})$ ]]; then
    echo "${val:1}FF" | tr 'a-f' 'A-F'
  elif [[ "$val" =~ ^rgba?\((.*)\)$ ]]; then
    IFS=',' read -ra parts <<< "${BASH_REMATCH[1]}"
    r=$(printf "%02X" $(echo "${parts[0]}" | tr -d ' '))
    g=$(printf "%02X" $(echo "${parts[1]}" | tr -d ' '))
    b=$(printf "%02X" $(echo "${parts[2]}" | tr -d ' '))
    a="FF"
    if [[ "${parts[3]}" != "" ]]; then
      a_float=$(echo "${parts[3]}" | tr -d ' ')
      a=$(printf "%02X" $(echo "$a_float * 255" | bc))
    fi
    echo "$r$g$b$a"
  else
    echo ""
  fi
}
get_css_color() {
  grep -Po "$1:\s*#\K[0-9a-fA-F]{6}" "$GTK_THEME_DIR/gtk.css" | head -n1 | awk '{print toupper($1)"FF"}'
}


# Get all required colors
BACKGROUND=$(get_color theme_bg_color)
MATCH=$(get_color accent_color)
SELECTION=$(get_color theme_selected_bg_color)
SELECTION_MATCH=$MATCH
SELECTION_TEXT=$(get_color theme_selected_fg_color)
TEXT=$(get_color theme_fg_color)
[ -z "$TEXT" ] && TEXT=$(get_css_color color)
SELECTION_MATCH=$MATCH
[ -z "$SELECTION_MATCH" ] && SELECTION_MATCH=$(get_css_color background-color)
BORDER=$MATCH
[ -z "$BORDER" ] && BORDER=$TEXT



# Fallbacks if not set
if [ -z "$MATCH" ] || [ "$MATCH" = "FF" ]; then
  MATCH=$(get_color theme_selected_bg_color)
  if [ -z "$MATCH" ] || [ "$MATCH" = "FF" ]; then
    MATCH="1E66F5FF" # fallback blue
  fi
fi

# Make backup of original fuzzel config
cp "$FUZZEL_CONFIG" "$FUZZEL_CONFIG.bak.$(date +%s)"

echo "BACKGROUND=$BACKGROUND"
echo "TEXT=$TEXT"
echo "MATCH=$MATCH"
echo "SELECTION=$SELECTION"
echo "SELECTION_MATCH=$SELECTION_MATCH"
echo "SELECTION_TEXT=$SELECTION_TEXT"
echo "BORDER=$BORDER"


# Update all fields

sed -i "s/^[[:space:]]*background[[:space:]]*=.*/        background = $BACKGROUND/" "$FUZZEL_CONFIG"
sed -i "s/^[[:space:]]*text[[:space:]]*=.*/        text = $TEXT/" "$FUZZEL_CONFIG"
sed -i "s/^[[:space:]]*match[[:space:]]*=.*/        match = $MATCH/" "$FUZZEL_CONFIG"
sed -i "s/^[[:space:]]*selection[[:space:]]*=.*/        selection = $SELECTION/" "$FUZZEL_CONFIG"
sed -i "s/^[[:space:]]*selection-match[[:space:]]*=.*/        selection-match = $SELECTION_MATCH/" "$FUZZEL_CONFIG"
sed -i "s/^[[:space:]]*selection-text[[:space:]]*=.*/        selection-text = $SELECTION_TEXT/" "$FUZZEL_CONFIG"
sed -i "s/^[[:space:]]*border[[:space:]]*=.*/        border = $BORDER/" "$FUZZEL_CONFIG"

WALL_DIR="$HOME/Pictures/walls"
echo ""
echo "Available Wallpapers:"

mapfile -t wallpapers < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' \))
if [ "${#wallpapers[@]}" -eq 0 ]; then
  echo "No wallpapers found in $WALL_DIR"
else
  for i in "${!wallpapers[@]}"; do
    echo "  [$((i+1))] $(basename "${wallpapers[$i]}")"
  done

  read -rp "Enter the number of the wallpaper to set (or leave blank to skip): " wall_num

  if [[ "$wall_num" =~ ^[0-9]+$ ]] && [ "$wall_num" -ge 1 ] && [ "$wall_num" -le "${#wallpapers[@]}" ]; then
    selected_wall="${wallpapers[$((wall_num-1))]}"
    echo "Setting wallpaper: $selected_wall"
    swww img "$selected_wall"
  else
    echo "Skipping wallpaper update."
  fi
fi
