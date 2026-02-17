# Debian Migration Guide (systemd)

Goal: reproduce the current NixOS desktop on Debian with systemd.
This guide focuses on base system parity; user apps can be installed via Nix after boot.

Target system highlights (from this repo):
- Boot: UEFI + GRUB (Debian default)
- Init: systemd
- Desktop: Wayland + labwc + Ly display manager
- Core services: NetworkManager, PipeWire, BlueZ/Blueman, CUPS, Syncthing, Tailscale, TLP
- UX helpers: gvfs, tumbler, gnome-keyring, xdg-desktop-portal
- Theming: Flexoki GTK, YAMIS icons, Graphite cursor, Iosevka Aile font

Assumptions (edit to match):
- Disk: /dev/nvme0n1
- EFI partition: 500M FAT32
- Swap: 16G partition OR a swapfile on Btrfs for laptops
- Root: Btrfs, ~2TB
- Hostname: Sed (or Zed)
- User: john
- Timezone: America/New_York
- Locale: en_US.UTF-8

---

## 1) Install base Debian

- Use the Debian netinst or live ISO.
- During install, pick:
  - Desktop: none (minimal install)
  - SSH: optional
  - Standard system utilities: yes

After first boot, update and install essentials:

```bash
sudo apt update
sudo apt -y upgrade
sudo apt -y install sudo git curl ca-certificates
```

## 1.1) Partitioning notes (UEFI + Btrfs)

During the installer, choose **Manual** partitioning and create:
- EFI System Partition: 500M, FAT32, mount at `/boot/efi`
- Swap: 16G (or skip and use swapfile)
- Root: Btrfs, rest of disk, mount at `/`

If you want subvolumes (`@`, `@home`), do it from a rescue shell after install:

```bash
sudo mount /dev/nvme0n1p3 /mnt
sudo btrfs subvolume create /mnt/@
sudo btrfs subvolume create /mnt/@home
sudo umount /mnt

sudo mount -o subvol=@ /dev/nvme0n1p3 /mnt
sudo mkdir -p /mnt/home
sudo mount -o subvol=@home /dev/nvme0n1p3 /mnt/home
```

## 2) Enable non-free-firmware (recommended)

Debian packages for firmware and some hardware drivers live in non-free-firmware.
Edit `/etc/apt/sources.list` like this (for bookworm):

```bash
sudo tee /etc/apt/sources.list << 'EOF'
# Debian Bookworm
# main + contrib + non-free + non-free-firmware

deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
EOF

sudo apt update
```

## 3) Base desktop packages

```bash
sudo apt -y install \
  labwc wayland-protocols xwayland wlroots \
  seatd \
  xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr \
  ly \
  pipewire pipewire-pulse wireplumber pavucontrol alsa-utils \
  network-manager network-manager-gnome \
  bluez blueman \
  cups cups-filters \
  gvfs tumbler gnome-keyring \
  mako-notifier waybar fuzzel \
  kitty fish zellij \
  thunar thunar-volman thunar-archive-plugin \
  swaylock swayidle wlogout \
  swww \
  brightnessctl grim slurp wl-clipboard wlr-randr
```

If any package is missing, note it and install via Nix later.

## 4) Users and groups

```bash
sudo usermod -aG sudo,video,audio,input,networkmanager,seat john
```

## 5) Enable services (systemd)

```bash
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable cups
sudo systemctl enable seatd
sudo systemctl enable ly

# Optional but matches NixOS config
sudo systemctl enable tlp
sudo systemctl enable tailscaled
sudo systemctl enable syncthing@john
```

PipeWire user services:

```bash
sudo -u john systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

## 5.1) Swapfile alternative (laptops)

If you prefer a swapfile on Btrfs instead of a swap partition:

```bash
sudo mkdir -p /swap
sudo chattr +C /swap
sudo fallocate -l 16G /swap/swapfile
sudo chmod 600 /swap/swapfile
sudo mkswap /swap/swapfile
sudo swapon /swap/swapfile
echo '/swap/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab
```

## 6) Theming (match NixOS look)

```bash
sudo apt -y install fonts-iosevka fonts-font-awesome

# Flexoki + YAMIS + Graphite are not guaranteed in Debian repos.
# Install via Nix or Git (after Nix is installed).
```

## 7) Configs from this repo

```bash
# Example: clone your config repo and link Wayland configs
mkdir -p ~/repos
cd ~/repos
# git clone <your repo> config

ln -s ~/repos/config/home/labwc ~/.config/labwc
ln -s ~/repos/config/home/waybar ~/.config/waybar
ln -s ~/repos/config/home/fuzzel ~/.config/fuzzel
ln -s ~/repos/config/home/raffi ~/.config/raffi
```

## 8) Optional: install Nix for apps

You said you will install Nix. After that, use your existing Nix configs
or `nix profile install` for:
- zen-browser, librewolf, vscodium
- obsidian, inkscape, vlc, etc.

---

## Quick reference: systemd

```bash
systemctl status <service>
systemctl enable --now <service>
journalctl -u <service> -b
```

---

## Package verification script

Run on the target system to check repo availability and get Nix fallback commands:



If you want a custom list, edit .


## References
- Debian Installation Guide: https://www.debian.org/releases/stable/installmanual
- Debian SourcesList (non-free-firmware): https://wiki.debian.org/SourcesList

---

## Full parity checklist (apps, services, configs)

This section mirrors the rest of your Nix config. Install distro-native packages where possible; if a package is
missing, use Nix.

### Package search (Debian)

```bash
apt search <name>
```

### Apps and tools to install (distro-native where feasible)

CLI + shells:
- fish, fisher, zoxide, nnn, zellij, kitty

Wayland + desktop utilities:
- waybar, mako, ferritebar, fuzzel, raffi, kanshi, wl-clipboard, grim, slurp, wlr-randr, wdisplays, wl-gammactl, wlopm

File management + disk tools:
- thunar, thunar-volman, thunar-archive-plugin, gvfs, xarchiver, qdirstat, czkawka, fclones-gui, gparted

Browsers + editors:
- zen-browser, librewolf, vscodium

Productivity + media:
- obsidian, vlc, inkscape, fontfinder, xnconvert, normcap, penpot-desktop, lunacy, koreader, readest

Dev tools:
- nodejs, bun, rust/cargo, gh (GitHub CLI), github-desktop, codeberg-cli, devtoolbox, n8n, love

System utilities:
- network-manager-gnome, blueman, pavucontrol, brightnessctl, usbimager, unetbootin, bleachbit, peazip, kopia-ui

Phone integration:
- android-tools, qtscrcpy, kdeconnect

Networking + sharing:
- qbittorrent, localsend, tailscale

Learning + misc:
- gtypist, amphetype, mupen64plus, minuet

AI + LLM tools:
- lmstudio, claude-desktop, helium

### Fonts + theming (minimum set)

Install at least:
- Iosevka + Nerd Font (Iosevka Term Slab), Font Awesome, Noto, Liberation
- Flexoki GTK, YAMIS icons, Graphite cursor (use Git or Nix if missing)

### User services parity

#### pCloud bisync (rclone)

Create script:

```bash
sudo tee /usr/local/bin/pcloud-bisync << 'EOF'
#!/bin/sh
set -euo pipefail
mkdir -p "$HOME/pCloud" "$HOME/.cache/rclone-bisync/pcloud"
exec rclone bisync pcloud: "$HOME/pCloud" \
  --workdir "$HOME/.cache/rclone-bisync/pcloud" \
  --size-only \
  --create-empty-src-dirs \
  --exclude "*.partial" \
  --exclude ".Trash-1000/**" \
  --exclude "**/.Trash-1000/**" \
  --exclude "**/node_modules/**" \
  --tpslimit 10 --tpslimit-burst 10 \
  --checkers 32 --transfers 16 \
  --fast-list \
  --retries 10 --retries-sleep 30s --low-level-retries 50 \
  --stats 30s -v
EOF
sudo chmod +x /usr/local/bin/pcloud-bisync
```

Systemd user timer:

```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/pcloud-bisync.service << 'EOF'
[Unit]
Description=rclone bisync pCloud <-> ~/pCloud
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/pcloud-bisync
EOF

cat > ~/.config/systemd/user/pcloud-bisync.timer << 'EOF'
[Unit]
Description=Timer: rclone bisync pCloud every 2 hours

[Timer]
OnBootSec=10m
OnUnitActiveSec=2h
RandomizedDelaySec=5m
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now pcloud-bisync.timer
```

#### Lid close behavior (wlopm)

If you want the lid-close behavior from Nix, install `wlopm` and use a udev/acpid or logind hook
to trigger `wlopm --off "*"` on lid close and `wlopm --on "*"` on open.

### Config parity (from this repo)

Ensure these are in place:
- `~/.config/labwc` (labwc config)
- `~/.config/waybar`
- `~/.config/fuzzel`
- `~/.config/raffi`
- `~/.config/kanshi` (if you use monitor profiles)
- `~/.zen` / autoconfig if you rely on Zen customizations

## Package verification script

Run on the target system to check repo availability and get Nix fallback commands:

```bash
~/repos/config/scripts/migrate/verify-packages-debian.sh
```

If you want a custom list, edit `scripts/migrate/package-list.txt`.

## One-command verification + service setup

If you want the “clone, run, done” flow:

```bash
~/repos/config/scripts/migrate/run.sh
```

This will:
- check all packages against your distro repos
- create a missing list + Nix fallback script
- generate service scripts for your init

Notes:
- You can disable auto installs with `AUTO_INSTALL_NATIVE=0`, `AUTO_INSTALL_NIX=0`, `AUTO_INSTALL_FLATPAK=0`.
- Flatpak fallbacks are listed in `scripts/migrate/flatpak-list.txt` and write to `/tmp/flatpak-missing.txt`.
- Per-distro lists live in `scripts/migrate/lists/` (edit freely).
