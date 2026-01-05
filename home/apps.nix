{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.labwcchanger-tui.packages.${pkgs.system}.default
  ];
}
