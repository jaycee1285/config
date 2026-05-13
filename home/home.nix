{ config, pkgs, ... }:

{
  home.username      = "john";
  home.homeDirectory = "/home/john";
  home.stateVersion  = "25.11";

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      source "$HOME/.config/bash/local.bash"
    '';
  };

  home.file.".config/bash/local.bash".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/john/repos/config/home/bash/local.bash";

  home.sessionVariables = {
    BROWSER = "librewolf";
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # Ferritor
      "text/plain" = [ "ferritor.desktop" ];
      "text/markdown" = [ "ferritor.desktop" ];
      "text/x-markdown" = [ "ferritor.desktop" ];
      "application/json" = [ "ferritor.desktop" ];
      "application/x-yaml" = [ "ferritor.desktop" ];
      "application/toml" = [ "ferritor.desktop" ];
      "text/x-toml" = [ "ferritor.desktop" ];
      "text/csv" = [ "ferritor.desktop" ];
      "text/tab-separated-values" = [ "ferritor.desktop" ];
      "text/x-rust" = [ "ferritor.desktop" ];
      "text/javascript" = [ "ferritor.desktop" ];
      "application/javascript" = [ "ferritor.desktop" ];
      "application/x-typescript" = [ "ferritor.desktop" ];

	  #Images

	  "application/pdf" = [ "org.kde.okular.desktop" "librewolf.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/bmp" = [ "org.gnome.Loupe.desktop" ];
      "image/tiff" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
      "image/avif" = [ "org.gnome.Loupe.desktop" ];
      "image/heif" = [ "org.gnome.Loupe.desktop" ];
      "image/heic" = [ "org.gnome.Loupe.desktop" ];

      # Browser
      "text/html" = [ "librewolf.desktop" ];
      "application/xhtml+xml" = [ "librewolf.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];

      # File manager
      "inode/directory" = [ "thunar.desktop" ];
      "application/x-gnome-saved-search" = [ "thunar.desktop" ];

      # Media
      "video/mp4" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/x-msvideo" = [ "vlc.desktop" ];
      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/flac" = [ "vlc.desktop" ];
      "audio/ogg" = [ "vlc.desktop" ];
      "audio/x-wav" = [ "vlc.desktop" ];
    };

    associations.added = {
      "text/plain" = [ "ferritor.desktop" ];
      "text/markdown" = [ "ferritor.desktop" ];
      "text/x-markdown" = [ "ferritor.desktop" ];
      "application/json" = [ "ferritor.desktop" ];
      "application/x-yaml" = [ "ferritor.desktop" ];
      "application/toml" = [ "ferritor.desktop" ];
      "text/x-toml" = [ "ferritor.desktop" ];
      "text/csv" = [ "ferritor.desktop" ];
      "text/tab-separated-values" = [ "ferritor.desktop" ];
      "text/x-rust" = [ "ferritor.desktop" ];
      "text/javascript" = [ "ferritor.desktop" ];
      "application/javascript" = [ "ferritor.desktop" ];
      "application/x-typescript" = [ "ferritor.desktop" ];
      "text/html" = [ "ferritor.desktop" "librewolf.desktop" ];
    };
  };

  imports = [
    ./apps.nix
    ./fonts.nix
    ./librewolf.nix
    ./fuzzel.nix
    ./gtk.nix
   ./kanshi.nix
    ./labwc.nix
    ./mako.nix
    ./sartwc.nix
  #  ./lid.nix
    ./scripts.nix
    ./ferritebar.nix
    ./theming.nix
    ./walls.nix
    ./raffi.nix

    # User package categories
    ./cli-tools.nix
    ./dev-tools.nix
    ./gui-apps.nix
    ./system-utilities.nix
    ./user-services.nix
  ];
}
