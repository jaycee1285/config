{ config, pkgs, unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      waybar = prev.waybar.override { withJson = true; };
    })
  ];

  environment.systemPackages = with pkgs; [

    # ───────────────────── core / base ─────────────────────
    openssl
    zlib
    glib
    gtk3
    gdk-pixbuf
    pkg-config
    clang
    gcc13
    dconf-editor
    eza
    wget
    git
    p7zip
    unzip
    unrar
    nixos-generators
    home-manager
    gnome-keyring
    libgnome-keyring
    jq
    kdePackages.kdialog

    # ─────────────── terminal & CLI tools ───────────────
    fish
    fishPlugins.fifc
    zoxide
    zellij
    kitty
    nnn

    # ───────────────── internet / browsers ────────────────
    pkgs.unstable.librewolf
    pkgs.unstable.chromium
    qbittorrent
    chawan
    localsend
    # pkgs.unstable.onedrivegui
    # pkgs.unstable.onedrive

    # ───────────── coding (editors, IDEs, toolchains) ─────────────
    # NOTE: multiple editors here on purpose so you can eyeball redundancies
    helix
    lapce
    lite-xl
    cudatext-gtk
    pragtical
    zee
    micro
    micro-with-wl-clipboard   # potential overlap with 'micro'
    marker
    typora
    ox
    flow-control              # text editor (programming-focused)
    featherpad               # lightweight GUI editor
    github-desktop
    gh
    nodejs-slim
    pkgs.unstable.bun
    flutter
    gearlever
    gtk3

    # ─────────────── wayland desktop & UX ───────────────
    pkgs.unstable.labwc
    pkgs.unstable.labwc-tweaks-gtk
    pkgs.unstable.labwc-menu-generator
    pkgs.unstable.waybar
    pkgs.unstable.sfwbar
    kdePackages.polkit-kde-agent-1
    lxqt.lxqt-wayland-session
    labwcchanger
    gowall

    # Launchers & finders
    rofi
    fuzzel
    bemenu
    albert                    # keyboard launcher

    # Notifications & text expansion
    mako
    libnotify
    espanso-wayland

    # Wallpaper & visuals
    swww

    # Screenshots & capture (grouped to reveal overlaps)
    wayshot
    flameshot                # moved here with other screenshot tools
    grim
    slurp
    swappy
    kooha

    # Locks & idle
    swaylock-effects
    swaylock-fancy
    swayidle
    wlogout

    # Portals & XWayland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    pkgs.unstable.xwayland
    pkgs.unstable.xwayland-run
    pkgs.unstable.xwayland-satellite

    # ─────────────── controls (bt/audio/brightness/network) ───────────────
    pkgs.unstable.blueman     # Bluetooth
    pavucontrol               # Audio control
    brightnessctl             # Brightness control
    networkmanagerapplet      # Network connections
    wdisplays

    # ─────────────────── phone integration ───────────────────
    android-tools
    scrcpy

    # ─────────────────── sync & backup ───────────────────
    pcloud
    duplicati
    pika-backup
    syncthing
    syncthingtray
    kopia-ui
    celeste                   # rclone wrapper (moved from gaming)

    # ─────────────────── media & graphics ───────────────────
    vlc
    inkscape-with-extensions
    fontfinder
    gnome-characters
    gucharmap

    # ───────────── files & storage (maintenance/utilities) ─────────────
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xarchiver
    qdirstat
    czkawka-full
    fclones-gui
    gparted

    # ───────────── imaging & boot media ─────────────
    usbimager
    unetbootin

    # ───────────── office & reading ─────────────
    pencil
    koreader

    # ───────────── app compatibility ─────────────
    appimage-run
    libappimage

    # ───────────── gaming ─────────────
    steam-run
    pkgs.unstable.better-control
    mupen64plus

    # ───────────── VPN & networking ─────────────
    wgnord
    wireguard-tools
    openresolv
    jq
    curl

    # ───────────── typing & learning ─────────────
    gtypist
    amphetype
    neothesia

    # ───────────── AI & LLM tools ─────────────
    cherry-studio
    lmstudio

    # ───────────── writing & grammar ─────────────
    eloquent

    # ───────────── theming (engines & tools) ─────────────
    themix-gui
    gtk-engine-murrine
    sassc
    flavours
    matugen
    wpgtk

    # (none)
    # extra items that didn’t fit above can be collected here intentionally
  ];
}
