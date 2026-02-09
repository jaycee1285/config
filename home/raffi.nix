{ config, pkgs, ... }:
let
  raffiRepoDir = "${config.home.homeDirectory}/repos/config/home/raffi";
in {
  xdg.configFile."raffi".source =
    config.lib.file.mkOutOfStoreSymlink raffiRepoDir;
  xdg.configFile."raffi".recursive = true;

  # Standard app launcher - fuzzel drun mode with icons
  home.file."bin/rf" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      exec ${pkgs.fuzzel}/bin/fuzzel
    '';
  };

  # Raffi utilities menu (clipboard, search, bookmarks, files, etc.)
  home.file."bin/rf-tools" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      printf '%s\n' clipboard search bookmarks files waybar-restart \
        | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt 'Tools: ' --width 30 \
        | xargs -r ${pkgs.raffi}/bin/raffi
    '';
  };

  # Power menu
  home.file."bin/rf-power" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      printf '%s\n' lock logout suspend reboot shutdown \
        | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt 'Power: ' --width 30 \
        | xargs -r ${pkgs.raffi}/bin/raffi
    '';
  };
}
