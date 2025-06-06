{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.options = "eurosign:e";
    desktopManager.xfce.enable = true;
    desktopManager.xfce.enableWaylandSession = true;
    desktopManager.budgie.enable = true;
    desktopManager.lxqt.enable = true;
  };
  services = {
  libinput.enable = true;
  displayManager.gdm.enable = true;
  };
  console.keyMap = "us";
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.plasma6.enable = true;
}
