{ config, pkgs, ... }:

{
  home.file."bin/fuzzwall".source = ./scripts/fuzzwall.sh;
  home.file."bin/barswitch".source = ./scripts/barswitch.sh;
  home.file."bin/reup".source = ./scripts/reup.sh;

  # fz – fuzzel mode-switch dispatcher and sub-scripts
  home.file."bin/fz".source          = ./scripts/fz.sh;
  home.file."bin/fz-bookmarks".source = ./scripts/fz-bookmarks.sh;
  home.file."bin/fz-clip".source     = ./scripts/fz-clip.sh;
  home.file."bin/fz-search".source   = ./scripts/fz-search.sh;
  home.file."bin/fz-files".source    = ./scripts/fz-files.sh;
  home.file."bin/fz-power".source    = ./scripts/fz-power.sh;

  home.sessionPath = [ "$HOME/bin" ];

  programs.bash.enable = true;
}
