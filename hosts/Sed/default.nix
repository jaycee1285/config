{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/audio.nix
    ../../modules/bootloader.nix
    ../../modules/flatpak.nix
    ../../modules/hardware.nix
    ../../modules/localization.nix
    ../../modules/nautilus.nix
    ../../modules/networking.nix
    ../../modules/nix-features.nix
    ../../modules/memory.nix
    ../../modules/system-packages.nix
    ../../modules/programs.nix
    ../../modules/services.nix
    ../../modules/system.nix
    ../../modules/users.nix
    ../../modules/xserver.nix
  ];

  # Host-specific settings for Sed
  networking.hostName = "Sed";
}
