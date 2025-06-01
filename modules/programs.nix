{ config, pkgs, ... }:
{
    programs.labwc.enable = true;
    programs.wayfire.enable = true;
    programs.niri.enable = true;
    programs.thunar.enable = true; # File manager
    programs.xfconf.enable = true; # Xfce configuration to allow storing preferences

}
