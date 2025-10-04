{ config, pkgs, zen-browser, ... }:

{
  environment.systemPackages = [
    zen-browser
  ];
}
