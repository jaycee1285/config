{ config, ... }:

  # Set GTK theme and font via dconf/gsettings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Orchis-Orange-Light-Compact";    # Replace with your theme name
      icon-theme = "Colloid";        # Optional: icon theme
      font-name = "Iosevka 12";    # Replace with your desired font and size
      cursor-theme = "Phinger-Cursors-Light";      # Optional: cursor theme
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Iosevka 12"; # Window title font
    };
  };
}
