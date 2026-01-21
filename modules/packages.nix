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
    pkgs.unstable.keychron-udev-rules


    # ─────────────── terminal & CLI tools ───────────────
    fish
    fishPlugins.fifc
    zoxide
    zellij
    kitty
    nnn

    # ───────────────── internet / browsers ────────────────
    qbittorrent
    chawan
    localsend
   (zen-browser.packages.${pkgs.system}.default)
    (claude-desktop.packages.${pkgs.system}.default)
    (helium-nix.packages.${pkgs.system}.default)
    # pkgs.unstable.onedrivegui
    # pkgs.unstable.onedrive
    zoom-us

    # ───────────── coding (editors, IDEs, toolchains) ─────────────
    # NOTE: multiple editors here on purpose so you can eyeball redundancies
    helix
    github-desktop
    gh
    nodejs-slim
    pkgs.unstable.bun
    flutter
    gtk3
    codex
    pkgs.unstable.opencode
    fjo
    codeberg-cli
    devtoolbox
    pkgs.unstable.n8n
    love
    cargo
    pkgs.unstable.fresh-editor
    pkgs.unstable.claude-code

    # ─────────────── productivity ───────────────
    pkgs.unstable.obsidian
    marker
    eloquent
    harper
    typesetter
    basalt
    kdePackages.kate
    abiword

    # ─────────────── wayland desktop & UX ───────────────
    pkgs.unstable.labwc
    pkgs.unstable.labwc-tweaks-gtk
    pkgs.unstable.labwc-menu-generator
    pkgs.unstable.waybar
    pkgs.unstable.sfwbar
    pkgs.unstable.mangowc
    kdePackages.polkit-kde-agent-1
    gowall
    wayfirePlugins.wf-shell
    wlr-layout-ui
    pkgs.unstable.dms-shell
    wlopm
    labwc-menu-generator

    # Launchers & finders
    rofi
    fuzzel
    bemenu               # keyboard launcher

    # Notifications & text expansion
    mako
    libnotify
    espanso-wayland
    harper
    swaynotificationcenter

    # Wallpaper & visuals
    swww

    # Screenshots & capture (grouped to reveal overlaps)
    flameshot                # moved here with other screenshot tools
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
    pkgs.unstable.pcloud
    duplicati
    pika-backup
    syncthing
    syncthingtray
    kopia-ui
    
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
    gnome-frog
    cbmp
    normcap
    lunacy
    penpot-desktop

    # ───────────── files & storage (maintenance/utilities) ─────────────
    thunar-volman
    thunar-archive-plugin
    xarchiver
    qdirstat
    czkawka-full
    fclones-gui
    gparted
    peazip
    bleachbit
    collector
    bazaar

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
    pkgs.kdePackages.qt6gtk2
    kdePackages.qtstyleplugin-kvantum

    # (none)
    # extra items that didn’t fit above can be collected here intentionally
  ];
}
