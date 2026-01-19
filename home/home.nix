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
    "inode/directory" = [ "org.kde.dolphin.desktop" ];
    "application/x-gnome-saved-search" = [ "org.kde.dolphin.desktop" ];
  };

  imports = [
    ./apps.nix
    ./fonts.nix
  #  ./firefox.nix
    ./flutter.nix
    ./fuzzel.nix
    ./gtk.nix
   ./kanshi.nix
    ./labwc.nix
    ./lid.nix
    ./scripts.nix
   # ./steam.nix
    ./vscodium.nix
    ./waybar.nix
    ./theming.nix
  ];
}
