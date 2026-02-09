{ config, pkgs, ... }:

{
  home.username      = "john";
  home.homeDirectory = "/home/john";
  home.stateVersion  = "25.11";

  programs.home-manager.enable = true;

  # One place for nixpkgs options that apply to *this* HM profile
  nixpkgs.config = {
    android_sdk.accept_license = true;   # let HM build the Android SDK
    allowUnfree                = true;   # needed by flutter → chromium, etc.
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = [ "thunar.desktop" ];
    "application/x-gnome-saved-search" = [ "thunar.desktop" ];
  };

  imports = [
    ./apps.nix
    ./fonts.nix
   # ./firefox.nix
    ./flutter.nix
    ./fuzzel.nix
    ./gtk.nix
    ./gtk-themes.nix
   ./kanshi.nix
    ./labwc.nix
    ./lid.nix
    ./scripts.nix
   # ./steam.nix
    ./tauri.nix
    ./vscodium.nix
    ./waybar.nix
    ./theming.nix
    ./walls.nix
    ./raffi.nix
    ./zen-autoconfig.nix
  ];
}
