{ config, pkgs, unstable, zen-browser, claude-desktop, helium-nix, ... }:

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
    fuse3
    fuse
    kdePackages.qtstyleplugin-kvantum
    themechanger
    nh
    nix-init 
    television


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
   (zen-browser.packages.${pkgs.system}.default)
    (claude-desktop.packages.${pkgs.system}.default)
    (helium-nix.packages.${pkgs.system}.default)
    # pkgs.unstable.onedrivegui
    # pkgs.unstable.onedrive

    # ───────────── coding (editors, IDEs, toolchains) ─────────────
    # NOTE: multiple editors here on purpose so you can eyeball redundancies
    helix
    lapce
    zed-editor
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
    pkgs.unstable.obsidian
    codex
    pkgs.unstable.opencode
    fjo
    codeberg-cli
    kdePackages.ghostwriter
    orbiton
    devtoolbox

    # ─────────────── wayland desktop & UX ───────────────
    pkgs.unstable.labwc
    pkgs.unstable.labwc-tweaks-gtk
    pkgs.unstable.labwc-menu-generator
    pkgs.unstable.waybar
    pkgs.unstable.sfwbar
    pkgs.unstable.mangowc
    kdePackages.polkit-kde-agent-1
    kdePackages.qtbase
    kdePackages.kwayland
    kdePackages.qtwayland
    labwcchanger
    gowall
    wayfirePlugins.wf-shell
    wlr-layout-ui
    pkgs.unstable.dms-shell
    wlopm

    # Launchers & finders
    rofi
    fuzzel
    bemenu
    albert                    # keyboard launcher

    # Notifications & text expansion
    mako
    libnotify
    espanso-wayland
    harper

    # Wallpaper & visuals
    swww

    # Screenshots & capture (grouped to reveal overlaps)
    wayshot
    flameshot                # moved here with other screenshot tools
    grim
    slurp
    swappy
    kooha
    vokoscreen-ng
    wayscriber

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
    wlr-randr
    wl-gammactl

    # ─────────────────── phone integration ───────────────────
    android-tools
    qtscrcpy
    kdePackages.kdeconnect-kde

    # ─────────────────── sync & backup ───────────────────
    pcloud
    duplicati
    pika-backup
    syncthing
    syncthingtray
    kopia-ui
    celeste                   # rclone wrapper (moved from gaming)
    rustdesk-server

    # ─────────────────── media & graphics ───────────────────
    vlc
    inkscape-with-extensions
    fontfinder
    gnome-characters
    gucharmap
    gowall
    conjure
    monophony
    xnconvert
    converseen
    gnome-frog
    cbmp
    normcap
    lunacy
    penpot-desktop

    # ───────────── files & storage (maintenance/utilities) ─────────────
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xarchiver
    qdirstat
    czkawka-full
    fclones-gui
    gparted
    hifile
    peazip
    resources
    bleachbit
    collector

    # ───────────── imaging & boot media ─────────────
    usbimager
    unetbootin

    # ───────────── office & reading ─────────────
    pencil
    koreader
    readest
    flowtime
    flow-state

    # ───────────── app compatibility ─────────────
    appimage-run
    libappimage

    # ───────────── gaming ─────────────
    steam-run
    pkgs.unstable.better-control
    mupen64plus
    kdePackages.minuet

    # ───────────── VPN & networking ─────────────
    wgnord
    wireguard-tools
    openresolv
    jq
    curl

    # ───────────── typing & learning ─────────────
    gtypist
    amphetype

    # ───────────── AI & LLM tools ─────────────
    cherry-studio
    lmstudio
    chatbox

    # ───────────── writing & grammar ─────────────
    eloquent
    harper
    typesetter
    pkgs.unstable.super-productivity
    basalt

    # ───────────── theming (engines & tools) ─────────────
    themix-gui
    gtk-engine-murrine
    sassc
    flavours
    matugen
    wpgtk
    graphite-gtk-theme
    stilo-themes
    materia-theme
    zuki-themes
    solarc-gtk-theme
    rewaita

    # (none)
    # extra items that didn’t fit above can be collected here intentionally
  ];
}
