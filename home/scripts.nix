{ config, pkgs, ... }:

{
  home.file."bin/reup".source = ./scripts/reup.sh;
  home.file."bin/barswitch".source = ./scripts/barswitch.sh;

  home.sessionPath = [ "$HOME/bin" ];

  programs.bash.enable = true;
}
