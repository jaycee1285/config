# Debian Migration Guide (SparkyOS)

Migration guide for recreating the Sed/Zed NixOS desktop setup on SparkyOS (Debian-based).

## Why SparkyOS?

SparkyOS is a lightweight Debian-based distribution with rolling and stable variants, extensive desktop options, and excellent hardware support. It provides a good balance between Debian stability and up-to-date packages.

---

## Pre-Installation

### Download SparkyOS
- Get the **SparkyOS Rolling** ISO (Debian Testing base) for latest packages
- Choose the "MinimalGUI" or "MinimalCLI" edition for a clean slate
- Download: https://sparkylinux.org/download/

### Create Bootable USB
```bash
# Using dd
sudo dd if=sparkylinux-*.iso of=/dev/sdX bs=4M status=progress && sync

# Or use usbimager/unetbootin
```

---

## Base System Installation

1. Boot from USB and run the installer
2. Select your preferred partitioning (recommend separate /home)
3. Set hostname to `Sed` or `Zed` as appropriate
4. Create user `john`

---

## Post-Installation Setup

### Update System
```bash
sudo apt update && sudo apt full-upgrade -y
```

### Enable Non-Free Repositories
```bash
sudo apt-add-repository contrib non-free non-free-firmware
sudo apt update
```

### Install Core Build Tools
```bash
sudo apt install -y build-essential git curl wget pkg-config \
    libssl-dev zlib1g-dev libglib2.0-dev libgtk-3-dev \
    libgdk-pixbuf2.0-dev clang gcc meson ninja-build cmake
```

---

## Desktop Environment: labwc

### Install Wayland Base
```bash
sudo apt install -y wayland-protocols libwayland-dev wlroots-dev \
    xwayland seatd libseat-dev
```

### Install labwc
```bash
# From Debian repos (may be older)
sudo apt install -y labwc

# Or build from source for latest:
git clone https://github.com/labwc/labwc.git
cd labwc
meson setup build -Dxwayland=enabled
ninja -C build
sudo ninja -C build install
```

### Install Display Manager (Ly)
```bash
# Build Ly from source
sudo apt install -y libpam0g-dev libxcb-xkb-dev
git clone --recurse-submodules https://github.com/fairyglade/ly
cd ly
make
sudo make install installsystemd
sudo systemctl enable ly.service
```

---

## Status Bar: Waybar

```bash
sudo apt install -y waybar

# Copy your waybar config
mkdir -p ~/.config/waybar
cp -r ~/repos/config/home/waybar/* ~/.config/waybar/
```

---

## Application Launcher: Fuzzel

```bash
sudo apt install -y fuzzel

# Copy config
mkdir -p ~/.config/fuzzel
cp -r ~/repos/config/home/fuzzel/* ~/.config/fuzzel/
```

---

## Notifications: Mako

```bash
sudo apt install -y mako-notifier libnotify-bin
```

---

## Wallpaper: swww

```bash
# Build from source (requires Rust)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

git clone https://github.com/LGFae/swww.git
cd swww
cargo build --release
sudo cp target/release/swww /usr/local/bin/
sudo cp target/release/swww-daemon /usr/local/bin/
```

---

## Lock Screen & Logout

```bash
# swaylock-effects
sudo apt install -y swaylock

# For swaylock-effects, build from source:
git clone https://github.com/jirutka/swaylock-effects.git
cd swaylock-effects
meson build
ninja -C build
sudo ninja -C build install

# wlogout
sudo apt install -y wlogout
```

---

## Audio: PipeWire

```bash
# Remove PulseAudio if present
sudo apt remove --purge pulseaudio

# Install PipeWire
sudo apt install -y pipewire pipewire-pulse pipewire-alsa \
    pipewire-jack wireplumber pavucontrol

# Enable services
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber
```

---

## Terminal & Shell

### Kitty Terminal
```bash
sudo apt install -y kitty
```

### Fish Shell
```bash
sudo apt install -y fish
chsh -s /usr/bin/fish

# Install fisher (plugin manager)
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

# Install zoxide
sudo apt install -y zoxide
echo "zoxide init fish | source" >> ~/.config/fish/config.fish
```

### Zellij
```bash
# Install from releases
wget https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
tar xf zellij-*.tar.gz
sudo mv zellij /usr/local/bin/
```

---

## File Managers

```bash
# Thunar
sudo apt install -y thunar thunar-volman thunar-archive-plugin

# Dolphin (KDE)
sudo apt install -y dolphin
```

---

## Web Browsers

### Zen Browser
```bash
# Download AppImage from https://zen-browser.app/
chmod +x zen-browser-*.AppImage
./zen-browser-*.AppImage --appimage-extract
sudo mv squashfs-root /opt/zen-browser
sudo ln -s /opt/zen-browser/zen /usr/local/bin/zen-browser
```

### LibreWolf (Flatpak)
```bash
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.gitlab.librewolf-community
```

---

## Development Tools

### VSCodium
```bash
wget -qO - https://gitlab.com/nickvergessen/vscodium-key.gpg.txt \
    | gpg --dearmor | sudo tee /usr/share/keyrings/vscodium-archive-keyring.gpg > /dev/null
echo 'deb [signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install -y codium
```

### Node.js & Bun
```bash
# Node.js via NodeSource
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Bun
curl -fsSL https://bun.sh/install | bash
```

### GitHub CLI
```bash
sudo apt install -y gh
```

### Flutter
```bash
sudo apt install -y clang cmake ninja-build libgtk-3-dev
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
```

---

## Productivity Apps

### Obsidian
```bash
# AppImage
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/Obsidian-1.5.3.AppImage
chmod +x Obsidian-*.AppImage
sudo mv Obsidian-*.AppImage /opt/obsidian.AppImage
```

---

## Services

### Bluetooth
```bash
sudo apt install -y bluetooth blueman bluez
sudo systemctl enable bluetooth
```

### Syncthing
```bash
sudo apt install -y syncthing
systemctl --user enable syncthing
systemctl --user start syncthing
```

### TLP (Power Management)
```bash
sudo apt install -y tlp tlp-rdw
sudo systemctl enable tlp

# Configure thresholds (edit /etc/tlp.conf)
sudo tee -a /etc/tlp.conf << 'EOF'
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
EOF
```

### Tailscale
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable tailscaled
sudo tailscale up
```

### Printing
```bash
sudo apt install -y cups system-config-printer
sudo systemctl enable cups
```

---

## Theming

### GTK Theme: Flexoki
```bash
git clone https://github.com/kepano/flexoki.git
mkdir -p ~/.themes
# Copy GTK theme variant to ~/.themes/Flexoki
```

### Icon Theme: YAMIS
```bash
git clone https://github.com/nicholasbien/yamis-icon-theme.git
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
sudo apt install -y fonts-font-awesome fonts-noto fonts-liberation

# Iosevka (download from GitHub releases)
wget https://github.com/be5invis/Iosevka/releases/download/v29.0.0/PkgTTC-IosevkaTermSlab-29.0.0.zip
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

Ensure your `~/.config/labwc/autostart` contains:
```bash
#!/bin/bash
swww-daemon &
waybar &
mako &
/usr/lib/polkit-kde-authentication-agent-1 &
blueman-applet &
nm-applet &
```

---

## XDG Portals

```bash
sudo apt install -y xdg-desktop-portal xdg-desktop-portal-gtk \
    xdg-desktop-portal-wlr
```

---

## Additional Utilities

```bash
# System utilities
sudo apt install -y brightnessctl grim slurp wl-clipboard \
    wlr-randr qdirstat gparted bleachbit

# Media
sudo apt install -y vlc inkscape

# Archives
sudo apt install -y p7zip-full unrar-free xarchiver

# VPN
sudo apt install -y wireguard-tools
```

---

## Flatpak Apps

```bash
flatpak install flathub \
    com.super_productivity.SuperProductivity \
    md.obsidian.Obsidian \
    com.github.tchx84.Flatseal
```

---

## Gaming (Optional)

```bash
# Steam
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y steam-installer

# Proton-GE: Download from https://github.com/GloriousEggroll/proton-ge-custom
mkdir -p ~/.steam/root/compatibilitytools.d/
```

---

## Troubleshooting

### labwc won't start
- Check `~/.local/state/labwc/labwc.log`
- Ensure seatd is running: `sudo systemctl start seatd`
- Add user to video group: `sudo usermod -aG video john`

### No sound
- Check PipeWire status: `systemctl --user status pipewire`
- Verify ALSA: `aplay -l`

### Bluetooth issues
- Restart bluetooth: `sudo systemctl restart bluetooth`
- Check rfkill: `rfkill list`

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
