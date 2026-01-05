{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Orchis-Orange-Light-Compact";
      icon-theme = "Colloid";
      font-name = "Iosevka Aile";
      cursor-theme = "Graphite-Cursors_light";
      color-scheme = "light";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Iosevka Aile 12";
    };
  };
}
