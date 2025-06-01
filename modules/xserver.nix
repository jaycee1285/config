{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    displayManager.gdm.enable = true;
    desktopManager.xfce.enable = true;
    desktopManager.xfce.enableWaylandSession = true;
    libinput.enable = true;
  };
  console.keyMap = "us";
}
