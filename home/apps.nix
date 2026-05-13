{ config, pkgs, unstable, base16changer, intentile, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = with pkgs; [
    embellish
    rink
    qalculate-gtk
    base16changer.packages.${system}.default
    material-design-icons
    rustc
    wayvnc
    webkitgtk_6_0
    filebrowser-quantum
    intentile.packages.${system}.default
    waybox
    way-displays
    wl-color-picker
    wl-clip-persist
	loupe
	kdePackages.okular
	gws
	noctalia-shell
  ];
}
