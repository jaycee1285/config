{ config, pkgs, ... }:

{
  home.file."bin/reup.sh".source = ./scripts/reup.sh;
  home.file."bin/reup.sh".executable = true;
  home.file."bin/barswitch".source = ./scripts/barswitch.sh;

  home.sessionPath = [ "$HOME/bin" ];

  programs.bash.enable = true;
}
