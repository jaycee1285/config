{ config, pkgs, super-productivity, ... }:

{
  environment.systemPackages = [
    super-productivity.packages.x86_64-linux.default
  ];
}
