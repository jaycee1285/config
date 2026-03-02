{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.options = "eurosign:e";
    desktopManager.lxqt.enable = true;
#    desktopManager.lxqt.extraPackages = [ pkgs.lxqt.lxqt-wayland-session ];
  };
  services.displayManager.ly = {
    enable = true;
  };

  security.soteria.enable = true;
  xdg.portal.wlr.enable = true;
  console.keyMap = "us";
  security.sudo.enable = true;
  security.sudo.extraRules = [{
    users = [ "john" ];
    commands = [
      { command = "/run/current-system/sw/bin/wgnord"; options = [ "NOPASSWD" ]; }
      { command = "${pkgs.wireguard-tools}/bin/wg";   options = [ "NOPASSWD" ]; }
    ];
  }];
}
