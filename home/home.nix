{ config, pkgs, ... }:

{
  home.username      = "john";
  home.homeDirectory = "/home/john";
  home.stateVersion  = "25.11";

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      export PATH="$HOME/.bun/bin:$PATH"
    '';
    shellAliases = {
      # NixOS
      nrs  = "sudo nixos-rebuild switch --flake /home/john/repos/config#$(hostname)";
      nrb  = "nixos-rebuild build --flake /home/john/repos/config#$(hostname)";
      nfu  = "nix flake update --flake /home/john/repos/config";
      ngc  = "sudo nix-collect-garbage -d";
      ndo  = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old";

      # eza → ls
      ls = "eza";
      ll = "eza -la --group-directories-first";
      lt = "eza --tree --level=2";
      la = "eza -a";

      # tools
      n    = "nnn -de";
      zj   = "zellij";
      zja  = "zellij attach";
      vpn  = "sudo wgnord connect";
      vpnd = "sudo wgnord disconnect";

      # dev launchers
      clr     = "cd ~/repos && claude";
      cdr     = "cd ~/repos && codex";
      nixconf = "cd /home/john/repos/config && fresh .";
    };
  };

  home.sessionVariables = {
    BROWSER = "librewolf";
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = [ "pcmanfm-qt.desktop" ];
    "application/x-gnome-saved-search" = [ "pcmanfm-qt.desktop" ];
    "text/html" = [ "librewolf.desktop" ];
    "x-scheme-handler/http" = [ "librewolf.desktop" ];
    "x-scheme-handler/https" = [ "librewolf.desktop" ];
  };

  imports = [
    ./apps.nix
    ./fonts.nix
    ./librewolf.nix
    ./fuzzel.nix
    ./gtk.nix
    ./gtk-themes.nix
   ./kanshi.nix
    ./labwc.nix
    ./sartwc.nix
  #  ./lid.nix
    ./scripts.nix
    ./tauri.nix
    ./vscodium.nix
    ./ferritebar.nix
    ./rustvox.nix
    ./waybar.nix
    ./theming.nix
    ./walls.nix
    ./raffi.nix

    # User package categories
    ./cli-tools.nix
    ./dev-tools.nix
    ./gui-apps.nix
    ./system-utilities.nix
    ./user-services.nix
  ];
}
