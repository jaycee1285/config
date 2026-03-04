{ pkgs, helium-nix, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = [
    # Browsers

    # Productivity
    pkgs.unstable.obsidian
    pkgs.harper
    pkgs.abiword
    pkgs.pencil
    pkgs.flowtime
    pkgs.flow-state
    pkgs.resources

    # Media
    pkgs.vlc
    pkgs.monophony
    pkgs.gnome-frog
    pkgs.spotube

    # Graphics & design
    pkgs.inkscape-with-extensions
    pkgs.xnconvert
    pkgs.cbmp
    pkgs.normcap
    pkgs.lunacy
    pkgs.penpot-desktop
    pkgs.conjure

    # Reading
    pkgs.koreader
    pkgs.readest

    # Phone integration
    pkgs.android-tools
    pkgs.qtscrcpy
    pkgs.kdePackages.kdeconnect-kde

    # File sharing
    pkgs.qbittorrent
    pkgs.localsend

    # Communication
    pkgs.zoom-us
    pkgs.teams-for-linux

    # Learning
    pkgs.gtypist
    pkgs.amphetype

    # Gaming
    pkgs.kdePackages.minuet

    # AI & LLM tools
    (helium-nix.packages.${system}.default)
    pkgs.mullvad-vpn
    pkgs.librechat
  ];
}
