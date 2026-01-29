# Emergency NixOS ISO with LabWC Environment
# ============================================
# Build with: nix build .#nixosConfigurations.iso.config.system.build.isoImage
# The ISO will be in ./result/iso/
#
# This creates a bootable live environment with your LabWC/Waybar/Fuzzel setup,
# pre-installed apps, and an install script to deploy your full config.

{ config, pkgs, lib, helium-nix, spredux, ... }:

let
  # Install script - placed on desktop and in /usr/local/bin
  installScript = pkgs.writeShellScriptBin "install-nixos" ''
    #!/usr/bin/env bash
    set -e

    cat << 'BANNER'
    ╔═══════════════════════════════════════════════════════════════════╗
    ║           NixOS Installation Script (jaycee1285/config)           ║
    ╠═══════════════════════════════════════════════════════════════════╣
    ║  This script will install NixOS with your custom configuration.   ║
    ║  Make sure you have:                                              ║
    ║    1. Partitioned your disk (use 'gparted' if needed)             ║
    ║    2. Formatted your partitions                                   ║
    ║    3. Mounted root at /mnt and boot at /mnt/boot                  ║
    ╚═══════════════════════════════════════════════════════════════════╝
    BANNER

    echo ""
    echo "=== STEP 1: Check Mounts ==="
    echo ""

    if ! mountpoint -q /mnt; then
      echo "ERROR: /mnt is not mounted!"
      echo ""
      echo "You need to partition and mount your disk first."
      echo ""
      echo "QUICK GUIDE:"
      echo "  1. Open GParted:  gparted"
      echo "  2. Create partitions:"
      echo "     - EFI System Partition (ESP): 512MB, FAT32, flags: boot,esp"
      echo "     - Root partition: rest of disk, ext4 (or btrfs)"
      echo "     - (Optional) Swap partition"
      echo ""
      echo "  3. Mount them:"
      echo "     sudo mount /dev/sdXY /mnt          # Your root partition"
      echo "     sudo mkdir -p /mnt/boot"
      echo "     sudo mount /dev/sdXZ /mnt/boot     # Your EFI partition"
      echo ""
      echo "  4. Run this script again: install-nixos"
      exit 1
    fi

    if ! mountpoint -q /mnt/boot; then
      echo "WARNING: /mnt/boot is not mounted!"
      echo "For UEFI systems, you need to mount your EFI partition at /mnt/boot"
      echo ""
      read -p "Continue anyway? (for legacy BIOS) [y/N] " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
      fi
    fi

    echo "Mounts look good!"
    echo ""
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep -E "(/mnt|NAME)"
    echo ""

    echo "=== STEP 2: Choose Host Configuration ==="
    echo ""
    echo "Available configurations:"
    echo "  1) Sed  - Primary laptop config"
    echo "  2) Zed  - Backup/secondary config"
    echo ""
    read -p "Choose [1/2]: " host_choice

    case $host_choice in
      1) HOST="Sed" ;;
      2) HOST="Zed" ;;
      *) echo "Invalid choice, defaulting to Sed"; HOST="Sed" ;;
    esac

    echo "Selected: $HOST"
    echo ""

    echo "=== STEP 3: Generate Hardware Configuration ==="
    echo ""
    sudo nixos-generate-config --root /mnt
    echo "Generated /mnt/etc/nixos/hardware-configuration.nix"
    echo ""

    echo "=== STEP 4: Install NixOS ==="
    echo ""
    echo "This will install NixOS with configuration: github:jaycee1285/config#$HOST"
    echo ""
    read -p "Ready to install? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Aborted."
      exit 1
    fi

    echo ""
    echo "Installing... (this may take a while)"
    echo ""

    sudo nixos-install --flake "github:jaycee1285/config#$HOST" --no-root-passwd

    echo ""
    echo "=== STEP 5: Post-Install ==="
    echo ""
    echo "Installation complete!"
    echo ""
    echo "IMPORTANT - Set your password:"
    echo "  sudo nixos-enter --root /mnt -c 'passwd john'"
    echo ""
    echo "Then reboot:"
    echo "  sudo reboot"
    echo ""
    echo "After first boot, clone your config for local edits:"
    echo "  mkdir -p ~/repos && cd ~/repos"
    echo "  git clone https://github.com/jaycee1285/config"
    echo ""
    echo "To update your system in the future:"
    echo "  cd ~/repos/config"
    echo "  sudo nixos-rebuild switch --flake .#$HOST"
    echo ""
    echo "Or update directly from GitHub:"
    echo "  sudo nixos-rebuild switch --flake github:jaycee1285/config#$HOST"
  '';

  # Simplified labwc rc.xml for live ISO (no flatpak refs, simplified keybinds)
  labwcRc = ''
    <?xml version="1.0"?>
    <labwc_config>
      <core>
        <decoration>server</decoration>
        <gap>0</gap>
        <adaptiveSync>yes</adaptiveSync>
      </core>
      <theme>
        <name>Adwaita</name>
        <cornerRadius>10</cornerRadius>
        <font>
          <name>Sans</name>
          <size>14</size>
        </font>
      </theme>
      <keyboard>
        <keybind key="Super_L" onRelease="yes">
          <action name="Execute" command="fuzzel"/>
        </keybind>
        <keybind key="A-Tab">
          <action name="NextWindow"/>
        </keybind>
        <keybind key="A-Return">
          <action name="Close"/>
        </keybind>
        <keybind key="W-Return">
          <action name="Execute" command="kitty"/>
        </keybind>
        <keybind key="W-space">
          <action name="Execute" command="codium"/>
        </keybind>
        <keybind key="W-f">
          <action name="Execute" command="thunar"/>
        </keybind>
        <keybind key="W-o">
          <action name="Execute" command="obsidian"/>
        </keybind>
        <keybind key="W-i">
          <action name="Execute" command="install-nixos"/>
        </keybind>
        <keybind key="XF86_MonBrightnessUp">
          <action name="Execute" command="brightnessctl set +10%"/>
        </keybind>
        <keybind key="XF86_MonBrightnessDown">
          <action name="Execute" command="brightnessctl set 10%-"/>
        </keybind>
        <keybind key="XF86_AudioLowerVolume">
          <action name="Execute" command="wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0"/>
        </keybind>
        <keybind key="XF86_AudioRaiseVolume">
          <action name="Execute" command="wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0"/>
        </keybind>
        <keybind key="XF86_AudioMute">
          <action name="Execute" command="wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"/>
        </keybind>
        <keybind key="W-m">
          <action name="ToggleMaximize" direction="both"/>
        </keybind>
        <keybind key="W-Left">
          <action name="ToggleSnapToEdge" direction="left"/>
        </keybind>
        <keybind key="W-Right">
          <action name="ToggleSnapToEdge" direction="right"/>
        </keybind>
      </keyboard>
      <libinput>
        <device>
          <naturalScroll>yes</naturalScroll>
        </device>
      </libinput>
      <windowSwitcher show="yes" preview="yes" outlines="yes"/>
      <snapping>
        <range>16</range>
        <topMaximize>yes</topMaximize>
      </snapping>
    </labwc_config>
  '';

  labwcMenu = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_menu>
      <menu id="root-menu" label="root-menu">
        <title label="Emergency ISO"></title>
        <item label="Install NixOS">
          <action name="Execute"><command>kitty -e install-nixos</command></action>
        </item>
        <separator></separator>
        <item label="Terminal">
          <action name="Execute"><command>kitty</command></action>
        </item>
        <item label="Files">
          <action name="Execute"><command>thunar</command></action>
        </item>
        <item label="VS Codium">
          <action name="Execute"><command>codium</command></action>
        </item>
        <item label="Obsidian">
          <action name="Execute"><command>obsidian</command></action>
        </item>
        <separator></separator>
        <item label="GParted (Partitioning)">
          <action name="Execute"><command>gparted</command></action>
        </item>
        <separator></separator>
        <item label="Reconfigure">
          <action name="Reconfigure"></action>
        </item>
        <item label="Reboot">
          <action name="Execute" command="systemctl reboot"></action>
        </item>
        <item label="Shutdown">
          <action name="Execute" command="systemctl poweroff"></action>
        </item>
      </menu>
    </openbox_menu>
  '';

  labwcAutostart = ''
    # Set wallpaper (solid color for live)
    swaybg -c "#1c1c1c" &

    # Panel
    waybar &

    # Notifications
    mako &

    # Show welcome message
    sleep 2 && notify-send "Welcome to NixOS Emergency ISO" "Press Super+I or right-click to install\n\nSuper = Fuzzel launcher\nSuper+Return = Terminal\nSuper+Space = VSCodium\nSuper+O = Obsidian\nSuper+F = Files" &
  '';

  labwcEnvironment = ''
    MOZ_ENABLE_WAYLAND=1
    ELECTRON_OZONE_PLATFORM_HINT=auto
    NIXOS_OZONE_WL=1
    QT_QPA_PLATFORM=wayland
    XDG_CURRENT_DESKTOP=wlroots
    XCURSOR_SIZE=24
  '';

  # Simplified waybar config for ISO
  waybarConfig = builtins.toJSON {
    layer = "top";
    position = "top";
    modules-left = [ "custom/install" ];
    modules-center = [ "wlr/taskbar" ];
    modules-right = [ "tray" "network" "pulseaudio" "battery" "clock" ];

    "custom/install" = {
      format = "  Install NixOS";
      on-click = "kitty -e install-nixos";
      tooltip = "Click to start NixOS installation";
    };

    clock = {
      format = "{:%H:%M}";
      format-alt = "{:%Y-%m-%d}";
    };

    battery = {
      format = "{icon} {capacity}%";
      format-icons = [ "" "" "" "" "" ];
    };

    network = {
      format-wifi = " {essid}";
      format-ethernet = " {ipaddr}";
      format-disconnected = " Disconnected";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "";
      format-icons.default = [ "" "" "" ];
    };

    "wlr/taskbar" = {
      format = "{icon}";
      icon-size = 24;
      on-click = "activate";
    };

    tray = {
      icon-size = 20;
      spacing = 5;
    };
  };

  waybarStyle = ''
    * {
      font-family: "Sans", "Material Design Icons";
      font-size: 14px;
    }
    window#waybar {
      background: rgba(30, 30, 30, 0.9);
      color: #ffffff;
    }
    #custom-install {
      background: #4CAF50;
      color: white;
      padding: 0 15px;
      border-radius: 5px;
      margin: 5px;
      font-weight: bold;
    }
    #custom-install:hover {
      background: #66BB6A;
    }
    #clock, #battery, #network, #pulseaudio, #tray {
      padding: 0 10px;
    }
    #taskbar button {
      padding: 0 5px;
    }
    #taskbar button.active {
      background: rgba(255,255,255,0.2);
    }
  '';

  fuzzelIni = ''
    [colors]
    background=1e1e1edd
    text=ffffffff
    match=4CAF50ff
    selection=333333ff
    selection-text=ffffffff
    border=4CAF50ff
  '';

in {
  imports = [
    "${pkgs.path}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # ISO metadata
  isoImage.isoName = lib.mkForce "nixos-emergency-labwc-${config.system.nixos.label}-x86_64.iso";
  isoImage.volumeID = lib.mkForce "NIXOS_EMERGENCY";

  # Allow unfree (for obsidian, vscode, etc)
  nixpkgs.config.allowUnfree = true;

  # Enable labwc
  programs.labwc.enable = true;

  # Greetd auto-login to labwc
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.labwc}/bin/labwc";
        user = "nixos";
      };
    };
  };

  # Network
  networking.wireless.enable = lib.mkForce false;
  networking.networkmanager.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Install script
    installScript

    # Core desktop
    labwc
    waybar
    fuzzel
    mako
    libnotify
    kitty
    swaybg

    # Your apps
    vscodium
    obsidian
    (helium-nix.packages.${pkgs.system}.default)
    (spredux.packages.${pkgs.system}.default)

    # Utilities
    thunar
    pavucontrol
    brightnessctl
    networkmanagerapplet

    # Install tools
    git
    gparted
    parted
    dosfstools  # mkfs.fat
    e2fsprogs   # mkfs.ext4
    btrfs-progs # mkfs.btrfs

    # Helpful extras
    wget
    curl
    vim
    htop
  ];

  # XDG portals for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Config files for nixos user
  system.activationScripts.setupLabwcConfig = ''
    # Create config directories
    mkdir -p /home/nixos/.config/labwc
    mkdir -p /home/nixos/.config/waybar
    mkdir -p /home/nixos/.config/fuzzel
    mkdir -p /home/nixos/Desktop

    # LabWC configs
    cat > /home/nixos/.config/labwc/rc.xml << 'EOF'
${labwcRc}
EOF

    cat > /home/nixos/.config/labwc/menu.xml << 'EOF'
${labwcMenu}
EOF

    cat > /home/nixos/.config/labwc/autostart << 'EOF'
${labwcAutostart}
EOF
    chmod +x /home/nixos/.config/labwc/autostart

    cat > /home/nixos/.config/labwc/environment << 'EOF'
${labwcEnvironment}
EOF

    # Waybar configs
    cat > /home/nixos/.config/waybar/config << 'EOF'
${waybarConfig}
EOF

    cat > /home/nixos/.config/waybar/style.css << 'EOF'
${waybarStyle}
EOF

    # Fuzzel config
    cat > /home/nixos/.config/fuzzel/fuzzel.ini << 'EOF'
${fuzzelIni}
EOF

    # Desktop shortcut for install script
    cat > /home/nixos/Desktop/Install-NixOS.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Install NixOS
Comment=Install NixOS with jaycee1285/config
Exec=kitty -e install-nixos
Icon=system-software-install
Terminal=false
Categories=System;
EOF
    chmod +x /home/nixos/Desktop/Install-NixOS.desktop

    # README on desktop
    cat > /home/nixos/Desktop/README.txt << 'EOF'
===========================================
    NixOS Emergency ISO - Quick Start
===========================================

KEYBOARD SHORTCUTS:
  Super (tap)     = Fuzzel launcher
  Super + Return  = Terminal
  Super + Space   = VSCodium
  Super + O       = Obsidian
  Super + F       = File manager
  Super + I       = Start installer
  Super + M       = Maximize window
  Super + Left/Right = Snap window

TO INSTALL:
  1. Click "Install NixOS" in waybar (top-left)
     OR run: install-nixos

  2. Follow the prompts - you'll need to:
     - Partition disk (use GParted from right-click menu)
     - Mount partitions at /mnt and /mnt/boot
     - Choose Sed or Zed config

PARTITIONING QUICK GUIDE (UEFI):
  1. Open GParted (right-click menu)
  2. Create GPT partition table if needed
  3. Create partitions:
     - 512MB FAT32 for /boot (set boot,esp flags)
     - Rest as ext4 for root
  4. Mount:
     sudo mount /dev/sdXY /mnt
     sudo mkdir -p /mnt/boot
     sudo mount /dev/sdXZ /mnt/boot

AFTER INSTALL:
  Clone your config locally:
    mkdir -p ~/repos && cd ~/repos
    git clone https://github.com/jaycee1285/config

  Update system:
    cd ~/repos/config
    sudo nixos-rebuild switch --flake .#Sed
EOF

    # Fix ownership
    chown -R nixos:users /home/nixos/.config
    chown -R nixos:users /home/nixos/Desktop
  '';

  # Nix settings for flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
