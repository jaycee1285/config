{ config, pkgs, ... }:

{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  security.rtkit.enable = true;
  hardware.graphics.enable = true;
  services.fwupd.enable = true;
  # add more hardware options as needed
}
