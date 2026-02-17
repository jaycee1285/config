# Alpine Linux Migration Guide (OpenRC)

Goal: reproduce the current NixOS desktop on Alpine Linux using OpenRC.
This guide focuses on base system parity; user apps can be installed via Nix or Flatpak after boot.

Target system highlights (from this repo):
- Boot: UEFI + GRUB (default in Alpine installer)
- Init: OpenRC
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

## 1) Install base Alpine

Boot the Alpine ISO and run the installer:

```bash
setup-alpine
```

Choices (suggested):
- Keyboard: us
- Hostname: Sed
- Network: configure
- Mirror: choose a fast mirror
- User: john (wheel)
- Disk: sys (install to disk)

After reboot:

```bash
sudo apk update
sudo apk upgrade
```

## 1.1) Partitioning notes (UEFI + Btrfs)

During `setup-alpine`, when asked about disk layout, choose a custom/managed option
that lets you set:
- EFI System Partition: 500M, FAT32, mount at `/boot/efi`
- Swap: 16G (or skip and use swapfile)
- Root: Btrfs, rest of disk, mount at `/`

## 2) Enable community repository

Edit `/etc/apk/repositories` and ensure community is enabled.
Then:

```bash
sudo apk update
```

## 3) Base desktop packages

```bash
sudo apk add \
  labwc wayland wayland-protocols xwayland wlroots \
  seatd \
  xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr \
  ly \
  pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol alsa-utils \
  networkmanager networkmanager-openrc network-manager-applet \
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

If any package is missing, install via Nix or Flatpak later.

## 4) Users and groups

```bash
sudo adduser john seat
sudo adduser john input
sudo adduser john video
sudo adduser john audio
sudo adduser john netdev
```

## 5) Enable services (OpenRC)

```bash
sudo rc-update add dbus default
sudo rc-update add seatd default
sudo rc-update add networkmanager default
sudo rc-update add bluetooth default
sudo rc-update add cupsd default
sudo rc-update add ly default

# Optional but matches NixOS config
sudo rc-update add tlp default
sudo rc-update add tailscale default
```

Start services now:

```bash
sudo rc-service dbus start
sudo rc-service seatd start
sudo rc-service networkmanager start
sudo rc-service bluetooth start
sudo rc-service cupsd start
sudo rc-service ly start
```

PipeWire user services (in your session):

```bash
pipewire &
pipewire-pulse &
wireplumber &
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
sudo apk add font-noto font-liberation ttf-font-awesome

# Flexoki + YAMIS + Graphite are not guaranteed in Alpine repos.
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

## Quick reference: OpenRC

```bash
rc-service <service> start|stop|restart|status
rc-update add <service> default
rc-update del <service> default
rc-status
```

---

## Package verification script

Run on the target system to check repo availability and get Nix fallback commands:



If you want a custom list, edit .


## References
- Alpine Installation Handbook: https://docs.alpinelinux.org/user-handbook/0.1a/Installing/setup_alpine.html
- Alpine Package Repositories: https://docs.alpinelinux.org/user-handbook/0.1a/Repositories.html
- OpenRC: https://docs.alpinelinux.org/user-handbook/0.1a/Working/openrc.html

---

## Full parity checklist (apps, services, configs)

This section mirrors the rest of your Nix config. Install distro-native packages where possible; if a package is
missing, use Nix or Flatpak.

### Package search (Alpine)

```bash
apk search -v <name>
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

OpenRC service (runs every 2 hours in a loop):

```bash
sudo tee /etc/init.d/pcloud-bisync << 'EOF'
#!/sbin/openrc-run
name="pcloud-bisync"
command="/usr/local/bin/pcloud-bisync"
command_background="yes"
pidfile="/run/pcloud-bisync.pid"

start() {
  ebegin "Starting ${name}"
  start-stop-daemon --start --make-pidfile --pidfile "${pidfile}" \
    --background --startas /bin/sh -- -c 'while true; do /usr/local/bin/pcloud-bisync; sleep 7200; done'
  eend $?
}

stop() {
  ebegin "Stopping ${name}"
  start-stop-daemon --stop --pidfile "${pidfile}"
  eend $?
}
EOF
sudo chmod +x /etc/init.d/pcloud-bisync
sudo rc-update add pcloud-bisync default
sudo rc-service pcloud-bisync start
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
~/repos/config/scripts/migrate/verify-packages-alpine.sh
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
