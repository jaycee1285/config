{ pkgs, coverpro, ... }:

{
  home.packages = [
    coverpro.packages.${pkgs.system}.default
  ];
}
