{ config, pkgs, claude-desktop, ... }:

{
  environment.systemPackages = [
    claude-desktop
  ];
}
