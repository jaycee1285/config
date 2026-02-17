# Void Linux Migration Guide (runit)

Goal: reproduce the current NixOS desktop on Void Linux using runit.
This guide focuses on base system parity; user apps can be installed via Nix after boot.

Target system highlights (from this repo):
- Boot: UEFI + GRUB
- Init: runit
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

## 1) Install base Void

- Use the **Void Linux glibc base** ISO (recommended for best compatibility).
- Boot ISO and run the installer:

```bash
void-installer
```

During install:
- Source: Network
- Locale: en_US.UTF-8
- Hostname: Sed
- User: john (wheel)
- Bootloader: GRUB

Partitioning (UEFI + Btrfs suggestion in installer):
- EFI System Partition: 500M, FAT32, mount at `/boot/efi`
- Swap: 16G (or skip and use swapfile)
- Root: Btrfs, rest of disk, mount at `/`

After reboot:

```bash
sudo xbps-install -Su
```

Enable non-free repo (optional but useful for firmware):

```bash
sudo xbps-install -S void-repo-nonfree
sudo xbps-install -Su
```

## 2) Base desktop packages

```bash
sudo xbps-install -S \
  labwc wayland wayland-protocols xorg-server-xwayland wlroots \
  seatd \
  xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr \
  ly \
  pipewire wireplumber alsa-pipewire pipewire-pulse pavucontrol alsa-utils \
  NetworkManager network-manager-applet \
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

If any package is missing, install via Nix later.

## 3) Users and groups

```bash
sudo usermod -aG wheel,video,audio,input,bluetooth,seat,network john
```

## 4) Enable services (runit)

Void uses runit. Services are enabled by symlinking service dirs into `/var/service`.

```bash
sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/seatd /var/service/
sudo ln -s /etc/sv/NetworkManager /var/service/
sudo ln -s /etc/sv/bluetoothd /var/service/
sudo ln -s /etc/sv/cupsd /var/service/
sudo ln -s /etc/sv/ly /var/service/

# Optional but matches NixOS config
sudo ln -s /etc/sv/tlp /var/service/
sudo ln -s /etc/sv/tailscaled /var/service/
```

PipeWire user services:

```bash
pipewire &
pipewire-pulse &
wireplumber &
```

## 4.1) Swapfile alternative (laptops)

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

## 5) Theming (match NixOS look)

```bash
sudo xbps-install -S font-awesome noto-fonts-ttf

# Flexoki + YAMIS + Graphite are not guaranteed in Void repos.
# Install via Nix or Git (after Nix is installed).
```

## 6) Configs from this repo

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

## 7) Optional: install Nix for apps

You said you will install Nix. After that, use your existing Nix configs
or `nix profile install` for:
- zen-browser, librewolf, vscodium
- obsidian, inkscape, vlc, etc.

---

## Quick reference: runit (Void)

```bash
# status/up/down/restart
sudo sv status <service>
sudo sv up <service>
sudo sv down <service>

# enable (symlink into /var/service)
sudo ln -s /etc/sv/<service> /var/service/

# disable
sudo rm /var/service/<service>
```

---

## Package verification script

Run on the target system to check repo availability and get Nix fallback commands:



If you want a custom list, edit .


## References
- Void Handbook: Services and daemons (runit): https://docs.voidlinux.org/config/services/index.html

---

## Full parity checklist (apps, services, configs)

This section mirrors the rest of your Nix config. Install distro-native packages where possible; if a package is
missing, use Nix.

### Package search (Void)

```bash
xbps-query -Rs <name>
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
- network-manager-applet, blueman, pavucontrol, brightnessctl, usbimager, unetbootin, bleachbit, peazip, kopia-ui

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

Runit service (runs every 2 hours in a loop):

```bash
sudo mkdir -p /etc/sv/pcloud-bisync
sudo tee /etc/sv/pcloud-bisync/run << 'EOF'
#!/bin/sh
exec 2>&1
while true; do
  /usr/local/bin/pcloud-bisync
  sleep 7200
done
EOF
sudo chmod +x /etc/sv/pcloud-bisync/run

# Enable service
sudo ln -s /etc/sv/pcloud-bisync /var/service/
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
~/repos/config/scripts/migrate/verify-packages-void.sh
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
