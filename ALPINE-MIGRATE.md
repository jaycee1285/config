# Alpine Linux Migration Guide

Migration guide for recreating the Sed/Zed NixOS desktop setup on Alpine Linux.

## Why Alpine?

Alpine Linux is an extremely lightweight, security-focused distribution using musl libc and busybox. It's excellent for minimalist setups, containers, and systems where resource efficiency matters. The tradeoff is that some software may need manual building due to musl/glibc differences.

---

## Pre-Installation

### Download Alpine
- Get the **Alpine Extended** ISO (includes more packages for desktop use)
- Download: https://alpinelinux.org/downloads/

### Create Bootable USB
```bash
# Using dd
sudo dd if=alpine-extended-*.iso of=/dev/sdX bs=4M status=progress && sync
```

---

## Base System Installation

### Boot and Run Setup
```bash
setup-alpine
```

During setup:
- Keyboard layout: `us`
- Hostname: `Sed` or `Zed`
- Network: Configure with NetworkManager (select `networkmanager` when asked)
- Root password: Set securely
- Timezone: Your timezone
- Disk: Select disk and use `sys` mode
- Package mirror: Choose nearest

### Create User
```bash
adduser john
addgroup john wheel
addgroup john video
addgroup john audio
addgroup john input
```

### Enable Community Repository
Edit `/etc/apk/repositories` and uncomment the community line:
```bash
vi /etc/apk/repositories
# Uncomment: http://dl-cdn.alpinelinux.org/alpine/v3.x/community
```

```bash
apk update
```

---

## Post-Installation Setup

### Install sudo
```bash
apk add sudo
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
```

### Install Core Build Tools
```bash
apk add build-base git curl wget meson ninja cmake pkgconf \
    linux-headers eudev-dev mesa-dev libinput-dev wayland-dev \
    wayland-protocols libxkbcommon-dev pixman-dev cairo-dev \
    pango-dev gdk-pixbuf-dev
```

### Enable Services at Boot
```bash
# OpenRC is Alpine's init system
rc-update add udev sysinit
rc-update add networkmanager default
rc-update add dbus default
```

---

## Desktop Environment: labwc

### Install wlroots and Dependencies
```bash
apk add wlroots wlroots-dev seatd libseat libseat-dev xwayland
```

### Enable seatd
```bash
rc-update add seatd default
rc-service seatd start
addgroup john seat
```

### Build labwc from Source
```bash
# Alpine repos may have labwc, check first:
apk search labwc

# If not available or outdated, build from source:
apk add libxml2-dev
git clone https://github.com/labwc/labwc.git
cd labwc
meson setup build -Dxwayland=enabled
ninja -C build
sudo ninja -C build install
```

### Install Display Manager (Ly) or Use TTY Login
```bash
# Option 1: Build Ly
apk add linux-pam-dev libxcb-dev
git clone --recurse-submodules https://github.com/fairyglade/ly
cd ly
make
sudo make install installopenrc
rc-update add ly default

# Option 2: Start labwc from TTY (simpler)
# Add to ~/.profile:
echo 'if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec labwc
fi' >> ~/.profile
```

---

## Status Bar: Waybar

```bash
apk add waybar

# Copy config
mkdir -p ~/.config/waybar
cp -r ~/repos/config/home/waybar/* ~/.config/waybar/
```

---

## Application Launcher: Fuzzel

```bash
apk add fuzzel

# Copy config
mkdir -p ~/.config/fuzzel
cp -r ~/repos/config/home/fuzzel/* ~/.config/fuzzel/
```

---

## Notifications: Mako

```bash
apk add mako libnotify
```

---

## Wallpaper: swww

```bash
# Requires Rust
apk add rust cargo
git clone https://github.com/LGFae/swww.git
cd swww
cargo build --release
sudo cp target/release/swww /usr/local/bin/
sudo cp target/release/swww-daemon /usr/local/bin/
```

---

## Lock Screen & Logout

```bash
apk add swaylock swayidle

# For swaylock-effects, build from source:
git clone https://github.com/jirutka/swaylock-effects.git
cd swaylock-effects
meson build
ninja -C build
sudo ninja -C build install

# wlogout may need building from source
git clone https://github.com/ArtsyMacaw/wlogout.git
cd wlogout
meson build
ninja -C build
sudo ninja -C build install
```

---

## Audio: PipeWire

```bash
apk add pipewire pipewire-pulse pipewire-alsa wireplumber \
    pipewire-tools pavucontrol alsa-utils

# Create user service directory
mkdir -p ~/.config/pipewire

# Start via dbus (add to autostart)
# PipeWire starts automatically with dbus session
```

Add to `~/.config/labwc/autostart`:
```bash
pipewire &
wireplumber &
pipewire-pulse &
```

---

## Terminal & Shell

### Kitty Terminal
```bash
apk add kitty
```

### Fish Shell
```bash
apk add fish
chsh -s /usr/bin/fish john

# Install fisher
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

# Zoxide
apk add zoxide
echo "zoxide init fish | source" >> ~/.config/fish/config.fish
```

### Zellij
```bash
# Download pre-built binary (musl version)
wget https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
tar xf zellij-*.tar.gz
sudo mv zellij /usr/local/bin/
```

---

## File Managers

```bash
# Thunar
apk add thunar thunar-volman thunar-archive-plugin gvfs

# For Dolphin (heavier, pulls in KDE deps)
apk add dolphin
```

---

## Web Browsers

### Zen Browser
```bash
# AppImage may not work on Alpine due to musl
# Try Flatpak instead (see Flatpak section)
# Or use native Firefox:
apk add firefox
```

### LibreWolf via Flatpak
```bash
apk add flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.gitlab.librewolf-community
```

**Note:** Many AppImages won't work on Alpine due to musl/glibc incompatibility. Use Flatpak or native packages instead.

---

## Development Tools

### VSCodium
```bash
# Use Flatpak for VSCodium on Alpine
flatpak install flathub com.vscodium.codium
```

### Node.js & Bun
```bash
# Node.js
apk add nodejs npm

# Bun (native musl build)
curl -fsSL https://bun.sh/install | bash
# Note: Bun has musl support but check releases for compatibility
```

### GitHub CLI
```bash
apk add github-cli
```

### Flutter
```bash
# Flutter requires glibc - use distrobox/toolbox for glibc container
apk add distrobox podman
distrobox create --name flutter-dev --image ubuntu:latest
distrobox enter flutter-dev
# Inside container: install flutter normally
```

---

## Productivity Apps

### Obsidian
```bash
# Use Flatpak
flatpak install flathub md.obsidian.Obsidian
```

---

## Services

### Bluetooth
```bash
apk add bluez blueman
rc-update add bluetooth default
rc-service bluetooth start
```

### Syncthing
```bash
apk add syncthing
# Create OpenRC service or run in autostart
```

### TLP (Power Management)
```bash
apk add tlp
rc-update add tlp default

# Configure /etc/tlp.conf
cat >> /etc/tlp.conf << 'EOF'
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
EOF
```

### Tailscale
```bash
apk add tailscale
rc-update add tailscale default
rc-service tailscale start
tailscale up
```

### Printing
```bash
apk add cups cups-filters
rc-update add cupsd default
```

---

## Theming

### GTK Theme: Flexoki
```bash
apk add gtk+3.0
git clone https://github.com/kepano/flexoki.git
mkdir -p ~/.themes
# Copy/adapt GTK theme to ~/.themes/Flexoki
```

### Icon Theme: YAMIS
```bash
git clone https://github.com/nicholasbien/yamis-icon-theme.git
mkdir -p ~/.icons
cp -r yamis-icon-theme/YAMIS ~/.icons/
```

### Cursor Theme: Graphite
```bash
git clone https://github.com/vinceliuice/Graphite-cursors.git
cd Graphite-cursors
./install.sh
```

### Fonts
```bash
# Core fonts
apk add font-noto font-liberation ttf-font-awesome

# Iosevka - download from releases
wget https://github.com/be5invis/Iosevka/releases/download/v29.0.0/PkgTTC-IosevkaTermSlab-29.0.0.zip
mkdir -p ~/.local/share/fonts
unzip PkgTTC-*.zip -d ~/.local/share/fonts/
fc-cache -fv

# Nerd Fonts
mkdir -p ~/.local/share/fonts/NerdFonts
cd ~/.local/share/fonts/NerdFonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/IosevkaTermSlab.zip
unzip IosevkaTermSlab.zip
fc-cache -fv
```

### Apply GTK Settings
```bash
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Flexoki
gtk-icon-theme-name=YAMIS
gtk-font-name=Iosevka Aile 11
gtk-cursor-theme-name=Graphite-Cursors_light
gtk-application-prefer-dark-theme=0
EOF
```

---

## labwc Configuration

```bash
mkdir -p ~/.config/labwc
cp ~/repos/config/home/labwc/* ~/.config/labwc/
```

Create `~/.config/labwc/autostart`:
```bash
#!/bin/sh
pipewire &
wireplumber &
pipewire-pulse &
swww-daemon &
waybar &
mako &
blueman-applet &
nm-applet &
```

Make executable:
```bash
chmod +x ~/.config/labwc/autostart
```

---

## XDG Portals

```bash
apk add xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr
```

---

## Additional Utilities

```bash
# System utilities
apk add brightnessctl grim slurp wl-clipboard wlr-randr

# Media
apk add vlc inkscape

# Archives
apk add p7zip unrar xarchiver

# VPN
apk add wireguard-tools
```

---

## Flatpak Setup (Recommended for Alpine)

Flatpak provides glibc-based containers, solving many compatibility issues:

```bash
apk add flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Useful Flatpaks for Alpine
flatpak install flathub \
    io.gitlab.librewolf-community \
    com.vscodium.codium \
    md.obsidian.Obsidian \
    com.super_productivity.SuperProductivity \
    com.github.tchx84.Flatseal
```

---

## Distrobox for glibc Apps

For apps that absolutely need glibc:

```bash
apk add distrobox podman

# Create Ubuntu container
distrobox create --name ubuntu-apps --image ubuntu:latest

# Enter and install glibc-only apps
distrobox enter ubuntu-apps
# Inside: apt install <package>

# Export apps to host
distrobox-export --app <application>
```

---

## Gaming (Optional)

```bash
# Steam requires glibc - use Flatpak
flatpak install flathub com.valvesoftware.Steam
```

---

## Alpine-Specific Considerations

### musl vs glibc
- Alpine uses musl libc, not glibc
- Many pre-built binaries (AppImages, some downloads) won't work
- Solutions: Flatpak, distrobox, or compile from source

### OpenRC vs systemd
- Alpine uses OpenRC, not systemd
- User services work differently - use autostart scripts
- Service commands: `rc-service <name> start/stop/restart`
- Enable at boot: `rc-update add <name> default`

### Fewer Packages
- Alpine has fewer packages than Debian/Arch
- Check `apk search <package>` before assuming availability
- Build from source or use Flatpak as fallback

---

## Troubleshooting

### labwc won't start
- Check seatd: `rc-service seatd status`
- Verify groups: `groups john` (should include seat, video, input)
- Check logs: `cat /var/log/messages | grep labwc`

### No sound
- Verify PipeWire is running: `pgrep pipewire`
- Check ALSA: `aplay -l`
- Ensure user is in audio group

### Flatpak apps look wrong
- Install GTK themes for Flatpak:
  ```bash
  flatpak install flathub org.gtk.Gtk3theme.Adwaita-dark
  ```
- Or override with Flatseal

### AppImage doesn't work
- Expected on Alpine (musl incompatibility)
- Use Flatpak version or build from source

---

## Quick Reference: Key Bindings

| Key | Action |
|-----|--------|
| Super (release) | Fuzzel launcher |
| Alt (release) | Kitty terminal |
| Win+Return | Kitty terminal |
| Win+W | LibreWolf browser |
| Win+F | Dolphin file manager |
| Win+O | Obsidian |
| Win+Space | VSCodium |
| Win+M | Maximize window |
| Win+Left/Right | Snap to edge |
| Alt+Tab | Window switcher |
| Alt+Return | Close window |
| Alt+X | wlogout |
| F3 | Screenshot (grim) |

---

## Quick Reference: OpenRC Commands

```bash
# Service management
rc-service <service> start|stop|restart|status

# Enable/disable at boot
rc-update add <service> default
rc-update del <service> default

# List services
rc-status

# System
poweroff
reboot
```
