{ config, pkgs, ... }:
let
  raffiRepoDir = "${config.home.homeDirectory}/repos/config/home/raffi";
in {
  xdg.configFile."raffi".source =
    config.lib.file.mkOutOfStoreSymlink raffiRepoDir;
  xdg.configFile."raffi".recursive = true;

  # Hybrid launcher: fuzzel drun + raffi custom entries
  home.file."bin/rf" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      RAFFI_CONFIG="''${XDG_CONFIG_HOME:-$HOME/.config}/raffi/raffi.yaml"
      MARKER="› "

      # Extract raffi entry keys (top-level keys that aren't 'addons')
      get_raffi_entries() {
        ${pkgs.gawk}/bin/awk '
          /^[a-zA-Z]/ && !/^#/ && !/^addons:/ {
            key = $0
            gsub(/:.*/, "", key)
            print key
          }
        ' "$RAFFI_CONFIG" 2>/dev/null | sort -u
      }

      # Get desktop app names from .desktop files
      get_desktop_apps() {
        for dir in \
          "/run/current-system/sw/share/applications" \
          "$HOME/.local/share/applications" \
          "/etc/profiles/per-user/$USER/share/applications" \
          "''${XDG_DATA_HOME:-$HOME/.local/share}/flatpak/exports/share/applications" \
          "/var/lib/flatpak/exports/share/applications"; do
          [ -d "$dir" ] && find "$dir" -maxdepth 1 -name '*.desktop' -printf '%f\n' 2>/dev/null
        done | sed 's/\.desktop$//' | sort -u
      }

      # Build combined menu
      build_menu() {
        # Raffi entries first, marked
        get_raffi_entries | while read -r entry; do
          echo "''${MARKER}''${entry}"
        done
        echo "---"
        # Then desktop apps
        get_desktop_apps
      }

      # Show menu and get selection
      selection=$(build_menu | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "Launch: " --width 50) || exit 0

      # Handle selection
      if [[ "$selection" == "---" ]]; then
        exit 0
      elif [[ "$selection" == "''${MARKER}"* ]]; then
        # Raffi entry - strip marker and run via raffi
        entry="''${selection#"$MARKER"}"
        exec ${pkgs.raffi}/bin/raffi "$entry"
      else
        # Desktop app - use gtk-launch
        exec ${pkgs.gtk3}/bin/gtk-launch "$selection" 2>/dev/null || exec "$selection"
      fi
    '';
  };

  home.file."bin/rf-power" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      printf '%s\n' lock logout suspend reboot shutdown \
        | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt 'Power: ' --width 30 \
        | xargs -r ${pkgs.raffi}/bin/raffi
    '';
  };
}
