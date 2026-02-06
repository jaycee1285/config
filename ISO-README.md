# NixOS Emergency ISO

A bootable live environment with your LabWC/Waybar/Fuzzel setup, pre-installed apps, and an install script to deploy your full config.

## Files Created/Modified

**`iso.nix`** - Complete ISO module with:
- LabWC + Waybar + Fuzzel pre-configured (embedded configs, not symlinks)
- Auto-login to LabWC as `nixos` user
- VSCodium, Obsidian, Helium, SPRedux pre-installed
- Install script available via:
  - Waybar button (top-left green "Install NixOS")
  - Right-click menu
  - Keyboard shortcut `Super+I`
  - Terminal command `install-nixos`
- GParted for partitioning
- Desktop README with keybinds and instructions

**`flake.nix`** - Added ISO configuration

---

## To Build the ISO

```bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

The ISO will be at `./result/iso/nixos-emergency-labwc-*.iso`

---

## What the Install Script Does

1. **Checks mounts** - Verifies `/mnt` and `/mnt/boot` are mounted
2. **Walks you through partitioning** if not ready (with GParted instructions)
3. **Lets you choose** Sed or Zed config
4. **Generates hardware-configuration.nix** for your machine
5. **Runs** `nixos-install --flake github:jaycee1285/config#Sed`
6. **Reminds you** to set password and reboot

---

## Live ISO Keybinds

| Key | Action |
|-----|--------|
| `Super` (tap) | Fuzzel launcher |
| `Super+I` | Start installer |
| `Super+Return` | Terminal |
| `Super+Space` | VSCodium |
| `Super+O` | Obsidian |
| `Super+F` | File manager |
| `Super+M` | Maximize |
| `Super+Left/Right` | Snap window |
| `Alt+Tab` | Switch windows |
| `Alt+Return` | Close window |

---

## Partitioning Quick Guide (UEFI)

1. Open GParted (right-click menu or run `gparted`)
2. Create GPT partition table if needed (Device > Create Partition Table)
3. Create partitions:
   - **512MB FAT32** for `/boot` (set `boot,esp` flags)
   - **Rest of disk as ext4** for root (or btrfs if preferred)
   - **(Optional)** Swap partition
4. Mount:
   ```bash
   sudo mount /dev/sdXY /mnt          # Your root partition
   sudo mkdir -p /mnt/boot
   sudo mount /dev/sdXZ /mnt/boot     # Your EFI partition
   ```
5. Run installer: `install-nixos`

---

## After Installation

### Set your password
```bash
sudo nixos-enter --root /mnt -c 'passwd john'
```

### Reboot
```bash
sudo reboot
```

### Clone your config locally (after first boot)
```bash
mkdir -p ~/repos && cd ~/repos
git clone https://github.com/jaycee1285/config
```

### Update your system
```bash
cd ~/repos/config
sudo nixos-rebuild switch --flake .#Sed
```

Or update directly from GitHub:
```bash
sudo nixos-rebuild switch --flake github:jaycee1285/config#Sed
```

---

## Note on LibreWolf

The ISO doesn't include LibreWolf since it was using flatpak in your main config. To add the nixpkgs version, edit `iso.nix` and add `librewolf` to `environment.systemPackages`.

---

## Changes

- Moved `installation-cd-minimal.nix` import from `iso.nix` to `flake.nix` to fix infinite recursion. Using `pkgs.path` inside `imports` caused a circular dependency since `pkgs` requires `config`, which requires evaluating `imports` first.
