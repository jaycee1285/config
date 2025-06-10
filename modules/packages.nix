{ config, pkgs, nixpkgs-unstable, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import nixpkgs-unstable {
        system = pkgs.system;
        config = config.nixpkgs.config;
      };
    })
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
    qtscrcpy
    localsend
    kdePackages.polkit-kde-agent-1
    pcloud
    qdirstat
    gowall

    # coding
    unstable.vscodium
    nodejs_24
    unstable.bun
    github-desktop
    gh
    gearlever
    
    # internet
    unstable.librewolf  
    qbittorrent
    unstable.chromium
    #unstable.onedrivegui
    #unstable.onedrive

    # wayland
    unstable.labwc-tweaks-gtk
    unstable.labwc-menu-generator
    rofi-wayland
    wlogout
    unstable.labwc
    unstable.waybar
    unstable.sfwbar
    fuzzel
    bemenu
    swww
    grim
    slurp
    swappy
    swaylock-effects
    unstable.xwayland
    espanso-wayland
    swaylock-fancy
    swayidle

    # Phone
    pixelflasher
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
    unstable.obsidian
    nnn
    pixelflasher
    cherry-studio
    #super-productivity
    jq
    amphetype
    kopia-ui
    warehouse

    # gaming
    mupen64plus

    # bluetooth
    unstable.blueman

    wpgtk
    swayidle
    android-tools

    # office
    inkscape
    pencil
    koreader

    # utilities
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
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
    greetd.tuigreet
    pavucontrol
    unrar
    syncthingtray
    syncthing
    gnome-characters
    gucharmap

    # icons and cursors
    unstable.kanagawa-icon-theme
    phinger-cursors
    papirus-icon-theme
    unstable.gruvbox-plus-icons

    # theming
    themechanger
    kdePackages.qtstyleplugin-kvantum    
  ];
}
