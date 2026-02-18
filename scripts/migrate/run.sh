#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LISTS_DIR="$BASE_DIR/lists"
FLATPAK_LIST="$BASE_DIR/flatpak-list.txt"

OS_ID="${ID:-}"
OS_LIKE="${ID_LIKE:-}"
if [ -r /etc/os-release ]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  OS_ID="${ID}"
  OS_LIKE="${ID_LIKE}"
fi

INIT=""
if [ -r /proc/1/comm ]; then
  INIT=$(cat /proc/1/comm)
fi

USER_NAME="${SUDO_USER:-$USER}"
AUTO_INSTALL_NATIVE=${AUTO_INSTALL_NATIVE:-1}
AUTO_INSTALL_NIX=${AUTO_INSTALL_NIX:-1}
AUTO_INSTALL_FLATPAK=${AUTO_INSTALL_FLATPAK:-1}

pick_list() {
  case "$OS_ID" in
    arch) echo "$LISTS_DIR/arch.txt";;
    artix) echo "$LISTS_DIR/artix.txt";;
    debian) echo "$LISTS_DIR/debian.txt";;
    devuan) echo "$LISTS_DIR/devuan.txt";;
    alpine) echo "$LISTS_DIR/alpine.txt";;
    void) echo "$LISTS_DIR/void.txt";;
    *)
      if echo "$OS_LIKE" | grep -qi debian; then
        echo "$LISTS_DIR/debian.txt"
      elif echo "$OS_LIKE" | grep -qi arch; then
        echo "$LISTS_DIR/arch.txt"
      else
        echo "$LISTS_DIR/arch.txt"
      fi
      ;;
  esac
}

pick_verifier() {
  case "$OS_ID" in
    arch) echo "$BASE_DIR/verify-packages-arch.sh";;
    artix) echo "$BASE_DIR/verify-packages-artix.sh";;
    debian) echo "$BASE_DIR/verify-packages-debian.sh";;
    devuan) echo "$BASE_DIR/verify-packages-devuan.sh";;
    alpine) echo "$BASE_DIR/verify-packages-alpine.sh";;
    void) echo "$BASE_DIR/verify-packages-void.sh";;
    *)
      if echo "$OS_LIKE" | grep -qi debian; then
        echo "$BASE_DIR/verify-packages-debian.sh"
      elif echo "$OS_LIKE" | grep -qi arch; then
        echo "$BASE_DIR/verify-packages-arch.sh"
      else
        echo "$BASE_DIR/verify-packages-arch.sh"
      fi
      ;;
  esac
}

list_file=$(pick_list)
verifier=$(pick_verifier)

if [ ! -f "$list_file" ]; then
  echo "List not found: $list_file" >&2
  exit 1
fi
if [ ! -x "$verifier" ]; then
  echo "Verifier not found or not executable: $verifier" >&2
  exit 1
fi

echo "Detected OS: ${OS_ID:-unknown} (like: ${OS_LIKE:-n/a})"
echo "Detected init: ${INIT:-unknown}"
echo "Using list: $list_file"

"$verifier" "$list_file" | tee /tmp/package-check.txt

ok=$(awk '/^OK /{print $2}' /tmp/package-check.txt || true)
missing=$(awk '/^MISS /{print $2}' /tmp/package-check.txt || true)

if [ -n "$ok" ]; then
  echo "$ok" > /tmp/native-ok.txt
  echo "#!/usr/bin/env bash" > /tmp/native-install.sh
  echo "set -euo pipefail" >> /tmp/native-install.sh
  case "$OS_ID" in
    arch|artix)
      echo "sudo pacman -Syu --needed $(tr '\n' ' ' < /tmp/native-ok.txt)" >> /tmp/native-install.sh
      ;;
    debian|devuan)
      echo "sudo apt-get update" >> /tmp/native-install.sh
      echo "sudo apt-get -y install $(tr '\n' ' ' < /tmp/native-ok.txt)" >> /tmp/native-install.sh
      ;;
    alpine)
      echo "sudo apk add $(tr '\n' ' ' < /tmp/native-ok.txt)" >> /tmp/native-install.sh
      ;;
    void)
      echo "sudo xbps-install -S $(tr '\n' ' ' < /tmp/native-ok.txt)" >> /tmp/native-install.sh
      ;;
    *)
      echo "# Unknown OS; install manually" >> /tmp/native-install.sh
      ;;
  esac
  chmod +x /tmp/native-install.sh
  echo "Native install script saved to /tmp/native-install.sh"
  if [ "$AUTO_INSTALL_NATIVE" = "1" ]; then
    /tmp/native-install.sh
  fi
fi

if [ -n "$missing" ]; then
  echo "$missing" > /tmp/missing-native.txt
  echo "#!/usr/bin/env bash" > /tmp/nix-fallback.sh
  echo "set -euo pipefail" >> /tmp/nix-fallback.sh
  echo "$missing" | while read -r pkg; do
    echo "nix profile install nixpkgs#${pkg}" >> /tmp/nix-fallback.sh
  done
  chmod +x /tmp/nix-fallback.sh
  echo "Missing list saved to /tmp/missing-native.txt"
  echo "Nix fallback script saved to /tmp/nix-fallback.sh"
  if [ "$AUTO_INSTALL_NIX" = "1" ]; then
    /tmp/nix-fallback.sh
  fi
fi

if [ -f "$FLATPAK_LIST" ]; then
  flatpak_missing=()
  while IFS= read -r line; do
    line="${line%%#*}"
    line="$(echo "$line" | xargs)"
    [ -z "$line" ] && continue
    if command -v flatpak >/dev/null 2>&1; then
      if ! flatpak info "$line" >/dev/null 2>&1; then
        flatpak_missing+=("$line")
      fi
    else
      flatpak_missing+=("$line")
    fi
  done < "$FLATPAK_LIST"

  if [ ${#flatpak_missing[@]} -gt 0 ]; then
    printf '%s\n' "${flatpak_missing[@]}" > /tmp/flatpak-missing.txt
    echo "#!/usr/bin/env bash" > /tmp/flatpak-install.sh
    echo "set -euo pipefail" >> /tmp/flatpak-install.sh
    echo "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo" >> /tmp/flatpak-install.sh
    for p in "${flatpak_missing[@]}"; do
      echo "flatpak install -y flathub ${p}" >> /tmp/flatpak-install.sh
    done
    chmod +x /tmp/flatpak-install.sh
    echo "Flatpak missing list saved to /tmp/flatpak-missing.txt"
    echo "Flatpak install script saved to /tmp/flatpak-install.sh"
    if [ "$AUTO_INSTALL_FLATPAK" = "1" ]; then
      /tmp/flatpak-install.sh
    fi
  fi
fi

case "$INIT" in
  systemd)
    "$BASE_DIR/gen-services.sh" systemd "$USER_NAME"
    ;;
  runit)
    "$BASE_DIR/gen-services.sh" runit "$USER_NAME"
    ;;
  openrc)
    "$BASE_DIR/gen-services.sh" openrc "$USER_NAME"
    ;;
  s6-svscan|s6-rc|s6)
    "$BASE_DIR/gen-services.sh" s6 "$USER_NAME"
    ;;
  *)
    echo "Unknown init. Run manually: $BASE_DIR/gen-services.sh <systemd|runit|openrc|s6> $USER_NAME" >&2
    ;;
esac
