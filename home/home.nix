{ config, pkgs, ... }:

{
  home.username = "john";               # Change to your actual user!
  home.homeDirectory = "/home/john";    # Adjust as needed

  programs.home-manager.enable = true;

  imports = [
    ./gtk.nix
    # Add more user modules here if you want (e.g., ./cli.nix, ./vim.nix, etc)
  ];
}
