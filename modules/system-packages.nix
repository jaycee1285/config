{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      waybar = prev.waybar.override { withJson = true; };
    })
  ];

  environment.systemPackages = with pkgs; [

    # ───────────────────── core / base ─────────────────────
    vmtouch
    openssl
    zlib
    glib
    gtk3
    gdk-pixbuf
    libGL
    libx11
    nss
    nspr
    atk
    cairo
    pango
    libepoxy
    pkg-config
    clang
    gcc13
    dconf-editor
    eza
    wget
    git
    p7zip
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
    pkgs.unstable.labwc-tweaks-gtk
    pkgs.unstable.labwc-menu-generator
    kdePackages.polkit-kde-agent-1
    gowall
    wlr-layout-ui
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

    # ───────────── VPN & networking ─────────────
    wgnord
    wireguard-tools
    openresolv
    curl

    # ───────────── theming (engines & tools) ─────────────
    gtk-engine-murrine
    sassc
    graphite-gtk-theme
    stilo-themes
    materia-theme
    zuki-themes
    solarc-gtk-theme
    rewaita
    pkgs.kdePackages.qt6gtk2
  ];
}
