{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Flexoki";
      icon-theme = "YAMIS";
      font-name = "Iosevka Aile";
      cursor-theme = "Graphite-Cursors_light";
      color-scheme = "light";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Iosevka Aile 12";
    };
  };
}
