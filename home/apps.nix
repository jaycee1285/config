{ config, pkgs, unstable, crustdown, base16changer, ... }:
let
  mdphr = pkgs.runCommand "mdphr" {} ''
    mkdir -p $out/bin
    ln -s ${crustdown.packages.${pkgs.system}.default}/bin/crustdown $out/bin/mdphr
  '';
in
{
  home.packages = with pkgs; [
    mdphr
    embellish
    heroic
    keychron-udev-rules
    base16changer.packages.${pkgs.system}.default
    material-design-icons
    qalculate-gtk
    rclone
    rclone-ui
    rustc
    pixieditor
    wayvnc
    webkitgtk_6_0
    zoxide
    television
    raffi
  ];
}
