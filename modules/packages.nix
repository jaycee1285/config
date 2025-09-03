{ config, pkgs, unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      waybar = prev.waybar.override { withJson = true; };
    })
  ];


  environment.systemPackages = with pkgs; [
    openssl
    themix-gui
    gtk-engine-murrine
    gdk-pixbuf
    sassc
    localsend
    kdePackages.polkit-kde-agent-1
    pcloud
    qdirstat
    gowall
    wayshot
    labwcchanger
    gcc13
    zlib
    cherry-studio
    lmstudio
    glib
    inkscape-with-extensions
    flow-control
    typora
    cudatext-gtk
    lite-xl 
    helix
    zee
    micro-with-wl-clipboard
    marker
    ox
    lapce
    libnotify
    mako
    eza
    dconf-editor
    pkgs.unstable.super-productivity
    xdg-desktop-portal-gtk
    flameshot
    chawan
    steam-run
    lxqt.lxqt-wayland-session
    czkawka-full
    pkgs.unstable.better-control
    wgnord
    flavours


    # coding
    nodejs-slim
    pkgs.unstable.bun
    github-desktop
    gh
    gearlever
    zellij
    micro
    flutter
    gtk3
    pkg-config
    clang
    ox
    pragtical
  

    #CLI
    fish
    fishPlugins.fifc
    zoxide
    
    # internet
    pkgs.unstable.librewolf  
    qbittorrent
    pkgs.unstable.chromium
    #pkgs.unstable.onedrivegui
    #pkgs.unstable.onedrive

    # wayland
    pkgs.unstable.labwc-tweaks-gtk
    pkgs.unstable.labwc-menu-generator
    rofi-wayland
    wlogout
    pkgs.unstable.labwc
    pkgs.unstable.waybar
    pkgs.unstable.sfwbar
    fuzzel
    bemenu
    swww
    grim
    slurp
    swappy
    swaylock-effects
    pkgs.unstable.xwayland
    espanso-wayland
    swaylock-fancy
    swayidle
    pkgs.unstable.xwayland-run
    pkgs.unstable.xwayland-satellite

    # Phone
    android-tools

    # mis
    neothesia
    celeste
    fclones-gui
    vlc 
    matugen
    usbimager
    unetbootin
    gtypist
    pkgs.unstable.obsidian
    nnn
    jq
    amphetype
    kopia-ui
#    warehouse

    # gaming
    mupen64plus

    # bluetooth
    pkgs.unstable.blueman

    wpgtk
    swayidle
    android-tools

    # office
    pencil
    koreader

    # utilities
    xdg-desktop-portal-wlr
    kitty
    fontfinder
    git
    wget
    p7zip
    unzip
    nixos-generators
    gnome-keyring
    libgnome-keyring
    home-manager
    brightnessctl
    featherpad
    fusuma
    networkmanagerapplet
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    appimage-run
    libappimage
    xarchiver
    pavucontrol
    unrar
    syncthingtray
    syncthing
    gnome-characters
    gucharmap

    # icons and cursors
    pkgs.unstable.kanagawa-icon-theme
    phinger-cursors
    papirus-icon-theme
    pkgs.unstable.gruvbox-plus-icons
    zafiro-icons
    nordzy-icon-theme
    graphite-cursors

    # theming 
  ];
}
