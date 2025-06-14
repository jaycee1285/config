{ config, pkgs, ... }:

{
  home.username = "john";               # Change to your actual user!
  home.homeDirectory = "/home/john";    # Adjust as needed
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
   home-manager.backupFileExtension = "backup";
   
  imports = [
    ./fuzzel.nix
    ./gtk.nix
    ./labwc.nix
    ./scripts.nix
    ./vscodium.nix
    ./waybar.nix
    # Add more user modules here if you want (e.g., ./cli.nix, ./vim.nix, etc)
  ];
}
