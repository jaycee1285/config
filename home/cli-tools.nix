{ config, pkgs, krust, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in

{
  home.packages = with pkgs; [
    # Core shell utilities
    curl
    wget
    git
    jq
    ripgrep
    sqlite

    # Modern CLI replacements / helpers
    eza
    nh
    nix-init

    # Navigation & file managers
    zoxide
    nnn

    # Multiplexers
    zellij

    # Local TUI tools
    krust.packages.${system}.default

    # Terminals
    kitty
  ];
}
