{ config, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Orchis-Orange-Light-Compact";
      icon-theme = "Colloid";
      font-name = "Iosevka 12";
      cursor-theme = "Phinger-Cursors-Light";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Iosevka 12";
    };
  };
}

