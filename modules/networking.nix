{ config, pkgs, ... }:
{
  networking = {
    hostName = "x13";
    networkmanager.enable = true;
    # wireless.enable = true;
     # Enable networking
  programs.nm-applet.enable = true;
  };
}
