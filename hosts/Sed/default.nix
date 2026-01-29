{ config, pkgs, ob-themes, zen-browser, claude-desktop, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/audio.nix
    ../../modules/bootloader.nix
    ../../modules/flatpak.nix
    ../../modules/hardware.nix
    ../../modules/localization.nix
#    ../../modules/nemo.nix
    ../../modules/networking.nix
    ../../modules/nix-features.nix
    ../../modules/packages.nix
    ../../modules/programs.nix
    ../../modules/services.nix
    ../../modules/system.nix
    ../../modules/users.nix
    ../../modules/xserver.nix
    ../../modules/ob-themes.nix
    ../../modules/zen-browser.nix
    ../../modules/claude-desktop.nix
    ../../modules/rclone-service.nix
  ];

  # Host-specific settings for Sed
  networking.hostName = "Sed";
}
