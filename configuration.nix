{ config, pkgs, gtk-themes, super-productivity, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/audio.nix
    ./modules/bootloader.nix
    ./modules/flatpak.nix
    ./modules/fonts.nix
    ./modules/gtk-themes.nix
    ./modules/hardware.nix
    ./modules/localization.nix
    ./modules/networking.nix
    ./modules/nix-features.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/services.nix
    ./modules/system.nix
    ./modules/users.nix
    ./modules/xserver.nix
    ./modules/super-productivity.nix
  ];

  # You can also set global overrides here, or import other .nix files
}
