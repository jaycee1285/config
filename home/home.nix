{ config, pkgs, ... }:

{
  home.username      = "john";
  home.homeDirectory = "/home/john";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  # One place for nixpkgs options that apply to *this* HM profile
  nixpkgs.config = {
    android_sdk.accept_license = true;   # let HM build the Android SDK
    allowUnfree                = true;   # needed by flutter → chromium, etc.
  };

  imports = [
    ./firefox.nix
    ./flutter.nix
    ./fuzzel.nix
    ./gtk.nix
   ./kanshi.nix
    ./labwc.nix
    ./scripts.nix
   # ./steam.nix
    ./vscodium.nix
    ./waybar.nix
  ];
}
