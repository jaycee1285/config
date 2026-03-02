{ config, pkgs, ... }:

{
  home.file."bin/reup.sh".source = ./scripts/reup.sh;
  home.file."bin/reup.sh".executable = true;
  home.file."bin/barswitch".source = ./scripts/barswitch.sh;
  home.file."bin/labwc-niri".source = ./scripts/labwc-niri;
  home.file."bin/labwc-niri".executable = true;
  home.file."bin/nfu".source = ./scripts/nfu;
  home.file."bin/nfu".executable = true;
  home.file."bin/dev-preload".source = ./scripts/dev-preload;
  home.file."bin/dev-preload".executable = true;
  home.file."bin/cdevc".source = ./scripts/cdevc;
  home.file."bin/cdevc".executable = true;
  home.file."bin/cdevcd".source = ./scripts/cdevcd;
  home.file."bin/cdevcd".executable = true;
  home.file."bin/sartwc-ipc".source = ./scripts/sartwc-ipc;
  home.file."bin/sartwc-ipc".executable = true;

  home.sessionPath = [ "$HOME/bin" ];

}
