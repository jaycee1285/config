{ config, pkgs, ... }:

{
  home.file."bin/reup.sh".source = ./scripts/reup.sh;
  home.file."bin/reup.sh".executable = true;
  home.file."bin/barswitch".source = ./scripts/barswitch.sh;
  home.file."bin/labwc-niri".source = ./scripts/labwc-niri;
  home.file."bin/labwc-niri".executable = true;

  home.sessionPath = [ "$HOME/bin" ];

  programs.bash.enable = true;
}
