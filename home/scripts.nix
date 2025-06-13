{ config, pkgs, ... }:

{
  home.file."bin/fuzzwall".source = ./scripts/fuzzwall.sh;
  home.file."bin/barswitch".source = ./scripts/barswitch.sh;

  home.sessionPath = [ "$HOME/bin" ];
}
