# Arch Linux Migration Guide (systemd)

Goal: reproduce the current NixOS desktop on Arch Linux with systemd.
This guide focuses on base system parity; user apps can be installed via Nix after boot.

Target system highlights (from this repo):
- Boot: UEFI + systemd-boot
- Init: systemd
- Desktop: Wayland + labwc + Ly display manager
- Core services: NetworkManager, PipeWire, BlueZ/Blueman, CUPS, Syncthing, Tailscale, TLP
- UX helpers: gvfs, tumbler, gnome-keyring, xdg-desktop-portal
- Theming: Flexoki GTK, YAMIS icons, Graphite cursor, Iosevka Aile font

Assumptions (edit to match):
- Disk: /dev/nvme0n1
- EFI partition: /dev/nvme0n1p1 (500M, FAT32)
- Swap: /dev/nvme0n1p2 (16G) OR a swapfile on Btrfs for laptops
- Root: /dev/nvme0n1p3 (Btrfs, ~2TB)
- Hostname: Sed (or Zed)
- User: john
- Timezone: America/New_York
- Locale: en_US.UTF-8

---

## 1) Boot ISO, network, time

```bash
# UEFI check (should exist)
ls /sys/firmware/efi/efivars

# Set keyboard if needed
loadkeys us

# Verify network
ping -c 3 archlinux.org
```

## 2) Partition and format (UEFI example)

```bash
# Example with gdisk
gdisk /dev/nvme0n1
# Create:
#  - p1: 500M, type EF00 (EFI)
#  - p2: 16G, type 8200 (swap)
#  - p3: rest, type 8300 (root, Btrfs)

mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.btrfs -L nixroot /dev/nvme0n1p3

# Optional but recommended: subvolumes
mount /dev/nvme0n1p3 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt
```

## 3) Mount

```bash
mount -o subvol=@ /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
mkdir -p /mnt/home
mount -o subvol=@home /dev/nvme0n1p3 /mnt/home
```

## 4) Install base system

```bash
pacstrap /mnt base linux linux-firmware sudo git networkmanager
```

Create fstab:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Chroot:

```bash
arch-chroot /mnt
```

## 5) System config

```bash
# Timezone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# Locale
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
cat > /etc/locale.conf << 'EOF_LOCALE'
LANG=en_US.UTF-8
EOF_LOCALE

# Hostname
cat > /etc/hostname << 'EOF_HOST'
Sed
EOF_HOST

cat > /etc/hosts << 'EOF_HOSTS'
127.0.0.1   localhost
::1         localhost
127.0.1.1   Sed.localdomain Sed
EOF_HOSTS
```

## 6) Users and sudo

```bash
useradd -m -G wheel,video,audio,input,networkmanager,seat -s /bin/bash john
passwd john
passwd

EDITOR=vim visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL
```

## 7) Bootloader (systemd-boot)

```bash
bootctl install

cat > /boot/loader/loader.conf << 'EOF_LOADER'
default arch.conf
timeout 3
EOF_LOADER

cat > /boot/loader/entries/arch.conf << 'EOF_ENTRY'
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3) rootflags=subvol=@ rw
EOF_ENTRY
```

## 8) Desktop base packages

```bash
pacman -Syu --needed \
  labwc wayland wayland-protocols xorg-xwayland wlroots \
  seatd xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr \
  ly \
  pipewire wireplumber pipewire-alsa pipewire-pulse pavucontrol alsa-utils \
  networkmanager network-manager-applet \
  bluez blueman \
  cups cups-filters \
  gvfs tumbler gnome-keyring \
  mako waybar fuzzel \
  kitty fish zellij \
  thunar thunar-volman thunar-archive-plugin \
  swaylock swayidle wlogout \
  swww \
  brightnessctl grim slurp wl-clipboard wlr-randr
```

## 9) Enable services (systemd)

```bash
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable seatd
systemctl enable ly

# Optional but matches NixOS config
systemctl enable tlp
systemctl enable tailscaled
systemctl enable syncthing@john
```

PipeWire user services:

```bash
sudo -u john systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

## 9.1) Swapfile alternative (laptops)

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

## 10) Theming (match NixOS look)

```bash
pacman -Syu --needed \
  ttf-iosevka ttf-iosevka-nerd ttf-font-awesome \
  gtk3 \
  papirus-icon-theme

# Flexoki + YAMIS + Graphite are not guaranteed in repos.
# If missing, install via Nix or Git (see Nix section).
```

## 11) Configs from this repo

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

## 12) Optional: install Nix for apps

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
- pacstrap(8) Arch manual page: https://man.archlinux.org/man/pacstrap.8
- genfstab(8) Arch manual page: https://man.archlinux.org/man/extra/arch-install-scripts/genfstab.8.en
- arch-chroot(8) Arch manual page: https://man.archlinux.org/man/arch-chroot.8
- bootctl(1) Arch manual page: https://man.archlinux.org/man/bootctl.1.en

---

## Full parity checklist (apps, services, configs)

This section mirrors the rest of your Nix config. Install distro-native packages where possible; if a package is
missing, use Nix.

### Package search (Arch)

```bash
pacman -Ss <name>
```

### Apps and tools to install (distro-native where feasible)

CLI + shells:
- fish, fisher, zoxide, nnn, zellij, kitty

Wayland + desktop utilities:
- waybar, mako, ferritebar, fuzzel, raffi, kanshi, wlsunset (optional), wl-clipboard, grim, slurp, wlr-randr, wdisplays, wl-gammactl, wlopm

File management + disk tools:
- thunar, thunar-volman, thunar-archive-plugin, gvfs, xarchiver, qdirstat, czkawka, fclones-gui, gparted

Browsers + editors:
- zen-browser, librewolf, vscodium

Productivity + media:
- obsidian, vlc, inkcape, fontfinder, xnconvert, normcap, penpot-desktop, lunacy, koreader, readest

Dev tools:
- nodejs, bun, rust/cargo, gh (GitHub CLI), github-desktop, codeberg-cli, devtoolbox, n8n, love

System utilities:
- networkmanager-applet, blueman, pavucontrol, brightnessctl, usbimager, unetbootin, bleachbit, peazip, kopia-ui

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
~/repos/config/scripts/migrate/verify-packages-arch.sh
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
