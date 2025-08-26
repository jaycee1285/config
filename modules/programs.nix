{ config, pkgs, ... }:
{
    programs.labwc.enable = true;
    programs.wayfire.enable = true;
    programs.niri.enable = true;
    programs.thunar.enable = true; # File manager
    programs.xfconf.enable = true; # Xfce configuration to allow storing preferences
    programs.nix-ld.enable = true;
    programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    protontricks.enable = true;
  };
}
