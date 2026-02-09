# Arch Linux Migration Guide

This document outlines the requirements for migrating from the current NixOS configuration to Arch Linux using `yay` as the AUR helper.

## Table of Contents

1. [Base System Installation](#base-system-installation)
2. [Package Installation](#package-installation)
3. [System Services](#system-services)
4. [Hardware Configuration](#hardware-configuration)
5. [Desktop Environment](#desktop-environment)
6. [User Configuration](#user-configuration)
7. [Application Configurations](#application-configurations)
8. [Custom Scripts](#custom-scripts)
9. [Development Environment](#development-environment)
10. [Post-Installation Tasks](#post-installation-tasks)

---

## Base System Installation

### Partition Scheme (match current layout)

| Mount Point | Filesystem | Current UUID |
|-------------|------------|--------------|
| `/` | Btrfs (subvolume `@`) | `b0e5715e-f849-4743-bf99-a59c45b11ae1` |
| `/boot` | FAT32 (EFI) | `0F00-0F17` |

### Bootloader

```bash
# Install systemd-boot
bootctl install

# Kernel parameters (for Intel graphics stability)
# Add to /boot/loader/entries/*.conf:
options root=UUID=b0e5715e-f849-4743-bf99-a59c45b11ae1 rootflags=subvol=@ rw i915.enable_psr=0 i915.enable_fbc=0
```

### Localization

```bash
# /etc/locale.gen - uncomment:
en_US.UTF-8 UTF-8

# Generate locales
locale-gen

# /etc/locale.conf
LANG=en_US.UTF-8

# /etc/vconsole.conf
KEYMAP=us

# Timezone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
```

### Hostname

```bash
echo "x13" > /etc/hostname
```

---

## Package Installation

### AUR Helper Installation

```bash
# Install yay (from base Arch install)
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

### Core System Packages

```bash
# Base system
yay -S linux linux-firmware intel-ucode btrfs-progs

# Essential tools
yay -S base-devel git curl wget jq openssl zlib glib2 gtk3 gdk-pixbuf2 pkg-config clang gcc
```

### Terminal & Shell

```bash
yay -S fish zoxide zellij kitty nnn eza fzf
```

### Networking

```bash
yay -S networkmanager network-manager-applet wireguard-tools openresolv
```

### Browsers

```bash
yay -S librewolf-bin qbittorrent zen-browser-bin
# chawan (AUR)
yay -S chawan
```

### Development Tools

```bash
# Editors
yay -S helix neovim vscodium-bin

# Version Control
yay -S github-desktop-bin github-cli codeberg-cli

# Languages & Runtimes
yay -S nodejs-lts-iron bun rustup go

# Build Tools
yay -S cmake ninja meson

# AI/LLM Tools
yay -S claude-code lm-studio-appimage chatbox-bin
# cherry-studio (may need manual install or flatpak)
```

### Wayland Desktop Components

```bash
# Compositors
yay -S labwc wayfire niri

# Bars & Panels
yay -S waybar sfwbar

# Launchers
yay -S rofi-wayland fuzzel bemenu

# Notifications
yay -S mako swaync

# Wallpaper & Screenshots
yay -S swww grim slurp flameshot

# Lock & Idle
yay -S swaylock-effects swayidle wlogout

# Display Management
yay -S wdisplays wlr-randr kanshi wl-gammactl wlopm

# Portals
yay -S xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
```

### Audio

```bash
yay -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
yay -S pavucontrol pamixer
```

### Bluetooth

```bash
yay -S bluez bluez-utils blueman
```

### File Management

```bash
yay -S thunar thunar-volman thunar-archive-plugin thunar-media-tags-plugin
yay -S tumbler gvfs gvfs-mtp gvfs-gphoto2
yay -S xarchiver qdirstat czkawka-gui gparted peazip-qt-bin bleachbit
yay -S dolphin  # KDE file manager (used for directories)
```

### Media & Graphics

```bash
yay -S vlc inkscape fontfinder gnome-characters
yay -S imagemagick ffmpeg
```

### Productivity

```bash
yay -S obsidian marker abiword
# koreader (AUR)
yay -S koreader-bin
```

### Office & Documents

```bash
yay -S libreoffice-fresh
```

### Sync & Backup

```bash
yay -S syncthing rclone duplicati2 pika-backup kopia-bin
# pcloud (AUR)
yay -S pcloud-drive
```

### Phone Integration

```bash
yay -S android-tools scrcpy kdeconnect
```

### Gaming

```bash
yay -S steam proton-ge-custom-bin protontricks
yay -S mupen64plus
```

### Theming Tools

```bash
yay -S themix-full gtk-engine-murrine sassc
yay -S wpgtk python-pywal
# flavours (AUR)
yay -S flavours
```

### GTK Themes

```bash
yay -S orchis-theme graphite-gtk-theme materia-gtk-theme nordic-theme
yay -S colloid-icon-theme-git graphite-cursors
```

### Power Management

```bash
yay -S tlp tlp-rdw powertop
```

### Miscellaneous

```bash
yay -S gnome-keyring seahorse
yay -S brightnessctl
yay -S localsend-bin
yay -S zoom
yay -S love  # Love2D game engine
```

### Fonts

```bash
# Nerd Fonts
yay -S ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-iosevkatermslab-nerd
yay -S ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-hack-nerd
yay -S ttf-sourcecodepro-nerd ttf-ubuntu-nerd ttf-roboto-mono-nerd
yay -S ttf-meslo-nerd ttf-cascadia-code-nerd ttf-victor-mono-nerd
yay -S ttf-zed-mono-nerd ttf-martian-mono-nerd otf-monaspace-nerd

# Google Fonts
yay -S ttf-google-fonts-git
# Or individual fonts:
yay -S ttf-inter ttf-poppins ttf-fira-sans ttf-roboto ttf-opensans

# Iosevka variants
yay -S ttf-iosevka ttc-iosevka-aile ttc-iosevka-etoile

# Additional fonts
yay -S ttf-ibm-plex ttf-liberation ttf-dejavu noto-fonts noto-fonts-emoji
```

---

## System Services

### Enable Core Services

```bash
# Network
sudo systemctl enable --now NetworkManager

# Bluetooth
sudo systemctl enable --now bluetooth

# Audio
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Power Management
sudo systemctl enable --now tlp

# Printing
sudo systemctl enable --now cups

# Syncthing (user service)
systemctl --user enable --now syncthing

# Gnome Keyring
# Add to PAM config or enable via display manager
```

### TLP Configuration

Create `/etc/tlp.conf`:

```conf
# Battery charge thresholds (ThinkPad)
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
```

### Rclone Bisync Timer

Create `~/.config/systemd/user/rclone-bisync.service`:

```ini
[Unit]
Description=Rclone Bisync pCloud
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/rclone bisync pcloud: /home/john/pCloud \
    --size-only \
    --create-empty-src-dirs \
    --compare size,modtime,checksum \
    --slow-hash-sync-only \
    --resilient \
    --recover \
    --conflict-resolve newer \
    --conflict-loser delete \
    --conflict-suffix sync-conflict-{DateOnly}- \
    --suffix-keep-extension \
    --checkers 32 \
    --transfers 16 \
    --fast-list \
    --retries 10 \
    --retries-sleep 30s \
    --exclude "*.partial" \
    --exclude ".Trash-1000/**" \
    --exclude "**/node_modules/**"

[Install]
WantedBy=default.target
```

Create `~/.config/systemd/user/rclone-bisync.timer`:

```ini
[Unit]
Description=Run Rclone Bisync every 2 hours

[Timer]
OnBootSec=10min
OnUnitActiveSec=2h
RandomizedDelaySec=5min

[Install]
WantedBy=timers.target
```

Enable:

```bash
systemctl --user enable --now rclone-bisync.timer
```

---

## Hardware Configuration

### Graphics (Intel)

```bash
yay -S mesa vulkan-intel intel-media-driver libva-intel-driver
```

### Firmware Updates

```bash
yay -S fwupd
sudo systemctl enable --now fwupd
```

### Realtime Audio (rtkit)

```bash
yay -S rtkit
```

---

## Desktop Environment

### Display Manager

```bash
yay -S ly
sudo systemctl enable ly

# Configure ly for Wayland sessions
# Edit /etc/ly/config.ini as needed
```

### Wayland Configuration (Quick Setup)

Clone the waylandconfig repo and symlink everything:

```bash
# Clone the config repo
git clone https://github.com/jaycee1285/waylandconfig.git ~/repos/waylandconfig

# Symlink all configs at once
ln -s ~/repos/waylandconfig/labwc ~/.config/labwc
ln -s ~/repos/waylandconfig/fuzzel ~/.config/fuzzel
ln -s ~/repos/waylandconfig/waybar ~/.config/waybar
ln -s ~/repos/waylandconfig/raffi ~/.config/raffi
```

### Raffi Launcher

Raffi replaces fuzzel scripts (fz-*) with a single YAML config.

```bash
# Install raffi
yay -S raffi-bin

# Dependencies for raffi scripts
yay -S fuzzel cliphist wl-clipboard sqlite ripgrep
```

Super key launches raffi. All launcher scripts (bookmarks, clipboard, files, power menu) are inlined in `~/.config/raffi/raffi.yaml`.

### Kanshi (Display Profiles)

Create `~/.config/kanshi/config`:

```conf
profile docked {
    output eDP-1 mode 1920x1080@60Hz position 0,0
    output DP-3 mode 1920x1080@60Hz position 1920,0
}

profile undocked {
    output eDP-1 mode 1920x1080@60Hz position 0,0
}
```

Enable as user service:

```bash
# Create ~/.config/systemd/user/kanshi.service or run from labwc autostart
```

---

## User Configuration

### Create User

```bash
useradd -m -G wheel,networkmanager,input -s /usr/bin/fish john
passwd john
```

### Sudo Configuration

Edit `/etc/sudoers.d/john`:

```
john ALL=(ALL) NOPASSWD: /usr/bin/wgnord
john ALL=(ALL) NOPASSWD: /usr/bin/wg
```

### Fish Shell

```bash
chsh -s /usr/bin/fish john
```

### XDG Directories

```bash
yay -S xdg-user-dirs
xdg-user-dirs-update
```

---

## Application Configurations

### GTK Theme

Create `~/.config/gtk-3.0/settings.ini`:

```ini
[Settings]
gtk-theme-name=Orchis-Orange-Light-Compact
gtk-icon-theme-name=Colloid
gtk-cursor-theme-name=Graphite-Cursors_light
gtk-font-name=Iosevka Aile 11
gtk-application-prefer-dark-theme=0
```

Create `~/.config/gtk-4.0/settings.ini` with same content.

### Qt Theme

Add to environment (e.g., `~/.config/labwc/environment`):

```bash
QT_QPA_PLATFORMTHEME=gnome
QT_STYLE_OVERRIDE=adwaita-dark
```

Install Qt integration:

```bash
yay -S qgnomeplatform-qt5 qgnomeplatform-qt6 adwaita-qt5 adwaita-qt6
```

### LibreWolf/Firefox

Extensions to install:

- Single File
- Sidebery
- FireShot
- Session Sync
- Link MD
- Theme extensions (Gruvbox Dark, Catppuccin, etc.)

Firefox settings (`about:config`):

```
toolkit.legacyUserProfileCustomizations.stylesheets = true
browser.ctrlTab.sortByRecentlyUsed = true
network.dns.disableIPv6 = true
```

### VSCodium

Install extensions via command line:

```bash
codium --install-extension arcticicestudio.nord-visual-studio-code
codium --install-extension enkia.tokyo-night
codium --install-extension sainnhe.gruvbox-material
codium --install-extension mvllow.rose-pine
codium --install-extension Dart-Code.dart-code
codium --install-extension svelte.svelte-vscode
codium --install-extension golang.go
codium --install-extension tauri-apps.tauri-vscode
# ... and other extensions
```

---

## Custom Scripts

### fuzzwall.sh (Theme Synchronizer)

Copy from `home/scripts/fuzzwall.sh` to `~/.local/bin/`

Dependencies:

```bash
yay -S fzf swww fuzzel
```

### Waybar Scripts

Copy scripts from `home/waybar/scripts/` to `~/.config/waybar/scripts/`:

- `clock.sh`
- `ram_icon.sh`
- `swap_icon.sh`
- `wg-icon`

Make executable:

```bash
chmod +x ~/.config/waybar/scripts/*
```

### Lid Handler Service

Create `~/.config/systemd/user/lid-handler.service`:

```ini
[Unit]
Description=Laptop Lid Event Handler
After=graphical-session.target

[Service]
Type=simple
ExecStart=/bin/bash -c 'while true; do state=$(cat /proc/acpi/button/lid/LID/state | tr -s " " | cut -d " " -f 2); if [ "$state" = "closed" ]; then wlopm --off "*"; else wlopm --on "*"; fi; sleep 2; done'
Restart=always

[Install]
WantedBy=default.target
```

---

## Development Environment

### Flutter & Android SDK

```bash
# Install Flutter
yay -S flutter android-sdk android-sdk-platform-tools android-sdk-build-tools

# Or use Android Studio
yay -S android-studio

# Accept licenses
flutter doctor --android-licenses

# Environment variables (~/.config/fish/config.fish or ~/.bashrc)
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### Rust

```bash
rustup default stable
rustup component add rust-analyzer
```

### Node.js

```bash
yay -S nodejs-lts-iron npm
# Or use nvm
yay -S nvm
```

---

## Post-Installation Tasks

### Flatpak Setup

```bash
yay -S flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Flatpak apps
flatpak install flathub com.superproductivity.SuperProductivity
```

### WireGuard/WGNord Setup

```bash
# Configure WireGuard
# Copy/generate WireGuard configs to /etc/wireguard/

# If using wgnord (NordVPN WireGuard)
yay -S wgnord
```

### pCloud Sync

```bash
# After installing pcloud-drive, configure sync directory
mkdir -p ~/pCloud
```

### Verify Hardware

```bash
# Check graphics
glxinfo | grep "OpenGL renderer"

# Check audio
pactl info

# Check Bluetooth
bluetoothctl show

# Check power management
tlp-stat -s
```

### Environment Variables

Add to `~/.config/labwc/environment` or shell rc file:

```bash
# Wayland
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=labwc
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland

# Theme
export GTK_THEME=Orchis-Orange-Light-Compact
export QT_QPA_PLATFORMTHEME=gnome
```

---

## Package Mapping Reference

| NixOS Package | Arch Package | Notes |
|---------------|--------------|-------|
| librewolf | librewolf-bin | AUR |
| vscodium | vscodium-bin | AUR |
| zen-browser | zen-browser-bin | AUR |
| claude-desktop | - | May need Flatpak or manual install |
| labwc | labwc | Community |
| wayfire | wayfire | Community |
| niri | niri | AUR |
| swaylock-effects | swaylock-effects | AUR |
| pcloud | pcloud-drive | AUR |
| proton-ge | proton-ge-custom-bin | AUR |
| github-desktop | github-desktop-bin | AUR |
| lm-studio | lm-studio-appimage | AUR |
| koreader | koreader-bin | AUR |
| super-productivity | Flatpak | flathub |

---

## Known Differences from NixOS

1. **Declarative vs Imperative**: Arch requires manual package management; consider using a dotfiles manager like `chezmoi` or `stow`
2. **Rollbacks**: No atomic rollbacks; consider using Btrfs snapshots with `snapper` or `timeshift`
3. **Flake packages**: Some custom flake packages may need manual building or alternatives
4. **Home Manager**: Consider using home-manager standalone or alternatives like `chezmoi`

### Recommended Additions for Arch

```bash
# Snapshot management (for Btrfs rollbacks like NixOS)
yay -S snapper snapper-gui snap-pac

# AUR helper management
yay -S paru  # Alternative to yay

# System maintenance
yay -S reflector pacman-contrib

# Dotfiles management
yay -S chezmoi stow
```

---

## Estimated Package Count

- **Official Repos**: ~150 packages
- **AUR**: ~50 packages
- **Flatpak**: ~5 applications
- **Manual/AppImage**: ~3 applications

Total: ~200+ packages (compared to 248 NixOS packages)
