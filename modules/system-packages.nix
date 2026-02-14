{ config, pkgs, unstable, zen-browser, claude-desktop, helium-nix, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "librewolf-bin-147.0.1-3"
  ];

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
    nh
    nix-init
    pkgs.unstable.keychron-udev-rules


    # ─────────────── wayland desktop & UX ───────────────
    pkgs.unstable.labwc
    pkgs.unstable.labwc-tweaks-gtk
    pkgs.unstable.labwc-menu-generator
    pkgs.unstable.waybar
    pkgs.unstable.mangowc
    kdePackages.polkit-kde-agent-1
    gowall
    wlr-layout-ui
    pkgs.unstable.dms-shell
    wlopm

    # Launchers & finders
    fuzzel
    cliphist
    wl-clipboard
    ripgrep
    sqlite

    # Notifications & text expansion
    mako
    libnotify
    espanso-wayland

    # Wallpaper & visuals
    swww

    # Screenshots & capture
    wayscriber

    # Locks & idle
    swaylock-effects
    swayidle
    wlogout

    # Portals & XWayland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    pkgs.unstable.xwayland
    pkgs.unstable.xwayland-run
    pkgs.unstable.xwayland-satellite

    # ───────────── app compatibility ─────────────
    appimage-run
    libappimage

    # ───────────── gaming (requires system integration) ─────────────
    steam-run

    # ───────────── VPN & networking ─────────────
    wgnord
    wireguard-tools
    openresolv
    curl

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
  ];
}
