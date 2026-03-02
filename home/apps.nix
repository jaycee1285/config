{ config, pkgs, unstable, crustdown, base16changer, intentile, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  mdphr = pkgs.runCommand "mdphr" {} ''
    mkdir -p $out/bin
    ln -s ${crustdown.packages.${system}.default}/bin/crustdown $out/bin/mdphr
  '';
in
{
  home.packages = with pkgs; [
    mdphr
    embellish
    rink
    qalculate-gtk
    heroic
    base16changer.packages.${system}.default
    material-design-icons
    rustc
    wayvnc
    webkitgtk_6_0
    filebrowser-quantum
    intentile.packages.${system}.default
  ];
}
