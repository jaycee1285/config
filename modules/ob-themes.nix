{ config, pkgs, ob-themes, ... }:

{
  environment.systemPackages = [
    ob-themes.packages.${pkgs.system}.default
  ];
}
