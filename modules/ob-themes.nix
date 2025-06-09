{ config, pkgs, ob-themes, ... }:

{
  environment.systemPackages = [
    ob-themes.packages.x86_64-linux
  ];
}
