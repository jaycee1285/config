{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Orchis-Light-Compact";
      icon-theme = "YAMIS";
      font-name = "Spline Sans 12";
      cursor-theme = "Graphite-Cursors_light";
      color-scheme = "light";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Spline Sans 12";
    };
  };
}
