{ pkgs, ... }:

let
  apps = import ../tauri.nix { inherit pkgs; };
in
{
  home.packages = [ apps.coverpro apps.daylight apps.jotter apps.openswarm apps.ferrite ];
}
