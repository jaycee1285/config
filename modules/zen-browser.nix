{ config, pkgs, zen-browser, ... }:

{
  environment.systemPackages = [
    zen-browser.packages.x86_64-linux.zen-browser
  ];
}
