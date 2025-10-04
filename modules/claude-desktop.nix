{ config, pkgs, claude-desktop, ... }:

{
  environment.systemPackages = [
    claude-desktop.packages.x86_64-linux.claude-desktop
  ];
}
