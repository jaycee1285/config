{ pkgs, spredux, ... }:

{
  home.packages = [
    spredux.packages.${pkgs.system}.default
  ];
}