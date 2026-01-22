{ config, pkgs, lib, ... }:

{
  networking = {
    hostName = lib.mkDefault "x13";
    networkmanager.enable = true;
    # wireless.enable = true; # Enable networking
  };

  programs.nm-applet.enable = true;
}
