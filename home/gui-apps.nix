{ pkgs, helium-nix, openswarm-src, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  apps = import ../tauri.nix { inherit pkgs openswarm-src; };
in
{
  home.packages = [
    # Browsers
	(helium-nix.packages.${system}.default)
    pkgs.mullvad-vpn

    # Productivity
    pkgs.harper
    pkgs.abiword
	pkgs.languagetool
    pkgs.pencil
    pkgs.flowtime
    pkgs.flow-state
    pkgs.claws-mail
    pkgs.gedit
	pkgs.typesetter
	pkgs.textcompare
	pkgs.vnote
	pkgs.kdePackages.kate
	pkgs.pdf4qt
	pkgs.centerpiece
    pkgs.drawy
	pkgs.enlightenment.ecrire

    # Media
    pkgs.vlc
    pkgs.monophony
    pkgs.gnome-frog
    pkgs.spotube
	pkgs.gtk-pipe-viewer

    # Graphics & design
    pkgs.inkscape-with-extensions
    pkgs.xnconvert
    pkgs.cbmp
    pkgs.normcap
    pkgs.lunacy
    pkgs.conjure
	pkgs.flameshot
	pkgs.lutgen-studio
	pkgs.emulsion-palette

    # Reading
    pkgs.koreader
    pkgs.readest

    # Phone integration
    pkgs.android-tools
    pkgs.qtscrcpy
    pkgs.kdePackages.kdeconnect-kde
	pkgs.pixelflasher

    # File sharing
	pkgs.rqbit
    pkgs.qbittorrent
    pkgs.localsend

    # Communication
    pkgs.zoom-us
	pkgs.enlightenment.evisum

    # Learning
    pkgs.gtypist
    pkgs.amphetype

    # Gaming
    pkgs.kdePackages.minuet

    # Custom GTK/Tauri apps
    apps.dotagent
    apps.ferritor
    apps.transcrust
    apps.serverbar
	apps.coverpro
	apps.openswarm
	apps.daylight

    # AI & LLM tools

    pkgs.librechat
    pkgs.aichat
    pkgs.llmfit
    pkgs.models-dev
    pkgs.opencode-desktop

	#Misc
	pkgs.fclones-gui
	pkgs.winboat
	pkgs.wl-kbptr
	pkgs.czkawka-full
	pkgs.pika-backup
  ];
}
