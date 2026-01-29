# Void Linux Migration Guide

Migration guide for recreating the Sed/Zed NixOS desktop setup on Void Linux.

## Why Void?

Void Linux is an independent, rolling-release distribution with its own package manager (XBPS) and init system (runit). It offers excellent performance, minimal bloat, and a curated package selection. Void provides both glibc and musl variants - this guide uses glibc for maximum compatibility.

---

## Pre-Installation

### Download Void
- Get the **Void Linux glibc base** ISO (or live ISO for easier install)
- Recommended: `void-live-x86_64-<date>-base.iso`
- Download: https://voidlinux.org/download/

### Create Bootable USB
```bash
# Using dd
sudo dd if=void-live-*.iso of=/dev/sdX bs=4M status=progress && sync
```

---

## Base System Installation

### Boot Live Environment
- Login: `root` / Password: `voidlinux` (or `anon`/`voidlinux` for live user)

### Run Installer
```bash
void-installer
```

During installation:
- Keyboard: `us`
- Network: Configure (will set up NetworkManager later)
- Source: `Network`
- Hostname: `Sed` or `Zed`
- Locale: `en_US.UTF-8`
- Timezone: Your timezone
- Root password: Set securely
- User: Create `john` with sudo access
- Bootloader: Install GRUB
- Partition: Your preferred scheme

### First Boot Setup
```bash
# Login as root and update
xbps-install -Su

# Enable non-free repository
xbps-install -S void-repo-nonfree
xbps-install -Su
```

---

## Post-Installation Setup

### Configure User Groups
```bash
usermod -aG wheel,video,audio,input,bluetooth john
```

### Install Core Tools
```bash
xbps-install -S base-devel git curl wget meson ninja cmake pkg-config \
    wayland-devel wayland-protocols wlroots-devel libinput-devel \
    mesa-devel libxkbcommon-devel pixman-devel cairo-devel pango-devel
```

### Enable Essential Services
```bash
# Void uses runit (symlink services to /var/service/)
ln -s /etc/sv/dbus /var/service/
ln -s /etc/sv/NetworkManager /var/service/

# Install NetworkManager first
xbps-install -S NetworkManager
```

---

## Desktop Environment: labwc

### Install Wayland Stack
```bash
xbps-install -S wlroots seatd libseat xwayland
ln -s /etc/sv/seatd /var/service/
```

### Install labwc
```bash
# Check if available in repos
xbps-query -Rs labwc

# If available:
xbps-install -S labwc

# Otherwise build from source:
xbps-install -S libxml2-devel
git clone https://github.com/labwc/labwc.git
cd labwc
meson setup build -Dxwayland=enabled
ninja -C build
sudo ninja -C build install
```

### Display Manager: Ly
```bash
# Build Ly
xbps-install -S pam-devel libxcb-devel
git clone --recurse-submodules https://github.com/fairyglade/ly
cd ly
make
sudo make install installrunit
ln -s /etc/sv/ly /var/service/
```

Or start from TTY - add to `~/.bash_profile`:
```bash
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec labwc
fi
```

---

## Status Bar: Waybar

```bash
xbps-install -S waybar

# Copy config
mkdir -p ~/.config/waybar
cp -r ~/repos/config/home/waybar/* ~/.config/waybar/
```

---

## Application Launcher: Fuzzel

```bash
xbps-install -S fuzzel

# Copy config
mkdir -p ~/.config/fuzzel
cp -r ~/repos/config/home/fuzzel/* ~/.config/fuzzel/
```

---

## Notifications: Mako

```bash
xbps-install -S mako libnotify
```

---

## Wallpaper: swww

```bash
# Install Rust
xbps-install -S rust cargo

git clone https://github.com/LGFae/swww.git
cd swww
cargo build --release
sudo cp target/release/swww /usr/local/bin/
sudo cp target/release/swww-daemon /usr/local/bin/
```

---

## Lock Screen & Logout

```bash
xbps-install -S swaylock swayidle

# swaylock-effects (build from source)
git clone https://github.com/jirutka/swaylock-effects.git
cd swaylock-effects
meson build
ninja -C build
sudo ninja -C build install

# wlogout
xbps-install -S wlogout
# Or build from source if not available
```

---

## Audio: PipeWire

```bash
xbps-install -S pipewire wireplumber alsa-pipewire \
    pavucontrol alsa-utils

# Enable PipeWire user services
mkdir -p ~/.config/pipewire
# Copy default configs
cp -r /usr/share/pipewire/* ~/.config/pipewire/
```

Add to `~/.config/labwc/autostart`:
```bash
pipewire &
wireplumber &
```

For system-wide Pipewire-pulse, create `/etc/asound.conf`:
```
pcm.!default {
    type pipewire
}
ctl.!default {
    type pipewire
}
```

---

## Terminal & Shell

### Kitty Terminal
```bash
xbps-install -S kitty
```

### Fish Shell
```bash
xbps-install -S fish-shell
chsh -s /usr/bin/fish john

# Install fisher
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

# Zoxide
xbps-install -S zoxide
echo "zoxide init fish | source" >> ~/.config/fish/config.fish
```

### Zellij
```bash
# Install from releases or cargo
xbps-install -S zellij
# Or:
cargo install zellij
```

---

## File Managers

```bash
# Thunar
xbps-install -S thunar thunar-volman thunar-archive-plugin gvfs

# Dolphin
xbps-install -S dolphin
```

---

## Web Browsers

### Zen Browser
```bash
# Download AppImage
wget https://github.com/nicholasbien/Zen-Browser/releases/latest/download/zen-browser-x86_64.AppImage
chmod +x zen-browser-*.AppImage
./zen-browser-*.AppImage --appimage-extract
sudo mv squashfs-root /opt/zen-browser
sudo ln -s /opt/zen-browser/zen /usr/local/bin/zen-browser
```

### LibreWolf
```bash
# Check Void repos
xbps-query -Rs librewolf

# If not available, use Flatpak:
xbps-install -S flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.gitlab.librewolf-community
```

### Firefox (fallback)
```bash
xbps-install -S firefox
```

---

## Development Tools

### VSCodium
```bash
# Void has vscodium in repos
xbps-install -S vscodium
```

### Node.js & Bun
```bash
# Node.js
xbps-install -S nodejs

# Bun
curl -fsSL https://bun.sh/install | bash
```

### GitHub CLI
```bash
xbps-install -S github-cli
```

### Flutter
```bash
xbps-install -S clang cmake ninja gtk+3-devel
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
```

---

## Productivity Apps

### Obsidian
```bash
# Download AppImage
wget https://github.com/obsidianmd/obsidian-releases/releases/latest/download/Obsidian-1.5.3.AppImage
chmod +x Obsidian-*.AppImage
sudo mv Obsidian-*.AppImage /opt/obsidian.AppImage

# Create desktop entry
cat > ~/.local/share/applications/obsidian.desktop << 'EOF'
[Desktop Entry]
Name=Obsidian
Exec=/opt/obsidian.AppImage
Icon=obsidian
Type=Application
Categories=Office;
EOF
```

---

## Services

### Bluetooth
```bash
xbps-install -S bluez blueman
ln -s /etc/sv/bluetoothd /var/service/
```

### Syncthing
```bash
xbps-install -S syncthing

# Create user service
mkdir -p ~/.config/sv/syncthing
cat > ~/.config/sv/syncthing/run << 'EOF'
#!/bin/sh
exec syncthing -no-browser -no-restart -logflags=0
EOF
chmod +x ~/.config/sv/syncthing/run

# Enable via user-level runit or add to autostart
```

### TLP (Power Management)
```bash
xbps-install -S tlp
ln -s /etc/sv/tlp /var/service/

# Configure
cat >> /etc/tlp.conf << 'EOF'
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
EOF
```

### Tailscale
```bash
xbps-install -S tailscale
ln -s /etc/sv/tailscaled /var/service/
tailscale up
```

### Printing
```bash
xbps-install -S cups cups-filters
ln -s /etc/sv/cupsd /var/service/
```

---

## Theming

### GTK Theme: Flexoki
```bash
xbps-install -S gtk+3
git clone https://github.com/kepano/flexoki.git
mkdir -p ~/.themes
# Copy/adapt GTK theme variant to ~/.themes/Flexoki
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
xbps-install -S font-awesome noto-fonts-ttf liberation-fonts-ttf

# Iosevka
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

Create/update `~/.config/labwc/autostart`:
```bash
#!/bin/sh
pipewire &
wireplumber &
swww-daemon &
waybar &
mako &
/usr/lib/polkit-kde-authentication-agent-1 &
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
xbps-install -S xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr
```

---

## Additional Utilities

```bash
# System utilities
xbps-install -S brightnessctl grim slurp wl-clipboard wlr-randr

# Media
xbps-install -S vlc inkscape

# Archives
xbps-install -S p7zip unrar xarchiver

# VPN
xbps-install -S wireguard-tools wireguard-dkms

# Disk utilities
xbps-install -S gparted
```

---

## Flatpak Setup

```bash
xbps-install -S flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install common Flatpaks
flatpak install flathub \
    com.super_productivity.SuperProductivity \
    com.github.tchx84.Flatseal
```

---

## Gaming (Optional)

```bash
# Enable multilib (32-bit) repository
xbps-install -S void-repo-multilib
xbps-install -Su

# Steam
xbps-install -S steam

# Proton-GE
mkdir -p ~/.steam/root/compatibilitytools.d/
# Download from https://github.com/GloriousEggroll/proton-ge-custom
```

---

## Void-Specific Considerations

### XBPS Package Manager
```bash
# Update system
xbps-install -Su

# Search packages
xbps-query -Rs <term>

# Install
xbps-install -S <package>

# Remove
xbps-remove <package>

# Remove orphans
xbps-remove -o

# Clean cache
xbps-remove -O
```

### Runit Init System
```bash
# Enable service
ln -s /etc/sv/<service> /var/service/

# Disable service
rm /var/service/<service>

# Check service status
sv status <service>

# Start/stop/restart
sv up <service>
sv down <service>
sv restart <service>

# List running services
sv status /var/service/*
```

### Creating User Services
```bash
# Create service directory
mkdir -p ~/.config/sv/myservice

# Create run script
cat > ~/.config/sv/myservice/run << 'EOF'
#!/bin/sh
exec chpst -u john mycommand
EOF
chmod +x ~/.config/sv/myservice/run

# To run user services, use a user-level runsvdir
# Add to ~/.xinitrc or autostart:
runsvdir ~/.config/sv &
```

### Kernel Updates
```bash
# Void uses DKMS for out-of-tree modules
xbps-install -S dkms

# After kernel updates, rebuild modules
dkms autoinstall
```

---

## Troubleshooting

### labwc won't start
- Check seatd: `sv status seatd`
- Verify user groups: `groups john`
- Check XDG_RUNTIME_DIR: `echo $XDG_RUNTIME_DIR`
- Look at logs: `cat ~/.local/state/labwc/labwc.log`

### No sound
- Verify PipeWire: `pgrep pipewire`
- Check ALSA devices: `aplay -l`
- Ensure asound.conf is configured

### Service not starting
- Check if linked: `ls -la /var/service/`
- Check service logs: `cat /var/service/<service>/supervise/stat`
- Verify run script is executable

### Package not found
- Update repos: `xbps-install -S`
- Check nonfree repo is enabled
- Search for alternatives: `xbps-query -Rs <term>`

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

## Quick Reference: XBPS Commands

```bash
# System update
xbps-install -Su

# Install package
xbps-install -S <package>

# Remove package
xbps-remove <package>

# Search packages
xbps-query -Rs <term>

# Show package info
xbps-query -R <package>

# List installed
xbps-query -l

# Clean cache
xbps-remove -O

# Remove orphans
xbps-remove -o
```

---

## Quick Reference: Runit Commands

```bash
# Enable service at boot
sudo ln -s /etc/sv/<service> /var/service/

# Disable service
sudo rm /var/service/<service>

# Service control
sudo sv start|stop|restart|status <service>

# View all service status
sudo sv status /var/service/*

# Force reload
sudo sv hup <service>
```
