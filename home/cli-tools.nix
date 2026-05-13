{ config, pkgs, openswarm-src, ... }:

let
  apps = import ../tauri.nix { inherit pkgs openswarm-src; };
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
    node-glob
    atuin
	ripgrep-all

    # Modern CLI replacements / helpers
    eza
    nh
    nix-init
	television

    # Navigation & file managers
    zoxide
    nnn
	fclones
	kondo
	dust
	dua
	xplr
	superfile
	projclean

	# Misc
	t-rec
	profile-cleaner
	pay-respects
	rsyncy
	nix-search-tv
	ripdrag
	treemd
	lutgen
	borgbackup

    # Multiplexers
    zellij

    # Local TUI tools
    apps.krust
	pastel

	# Internet/Agents Help
	papeer
	#defuddle-cli
	aerc

    # Terminals
    kitty
  ];
}
