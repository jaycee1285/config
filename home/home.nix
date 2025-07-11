{ config, pkgs, ... }:

{
  home.username = "john";               # Change to your actual user!
  home.homeDirectory = "/home/john";    # Adjust as needed
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;


  imports = [
    ./firefox.nix
    ./flutter.nix
    ./fuzzel.nix
    ./gtk.nix
   # ./kanshi.nix
    ./labwc.nix
    ./scripts.nix
    ./vscodium.nix
    ./waybar.nix
    # Add more user modules here if you want (e.g., ./cli.nix, ./vim.nix, etc)
  ];
}
