{ config, pkgs, ... }:
{
    programs.labwc.enable = true;
    programs.niri.enable = true;
    programs.fuse.enable = true;
    programs.fuse.userAllowOther = true;
    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
    programs.xfconf.enable = true; # Xfce configuration to allow storing preferences
    programs.nix-ld.enable = true;
    programs.wayvnc.enable = true;
    programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    protontricks.enable = true;
  };
}
