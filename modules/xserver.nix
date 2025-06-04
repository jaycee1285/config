{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.Options = "eurosign:e";
    displayManager.gdm.enable = true;
    desktopManager.xfce.enable = true;
    desktopManager.xfce.enableWaylandSession = true;
    libinput.enable = true;
  };
  console.keyMap = "us";
}
