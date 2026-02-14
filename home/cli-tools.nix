{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shells
    fish
    fishPlugins.fifc

    # Navigation & file managers
    zoxide
    nnn

    # Multiplexers
    zellij

    # Terminals
    kitty
  ];
}
