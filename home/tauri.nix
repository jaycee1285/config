{ pkgs, ... }:

let
  apps = import ../tauri.nix { inherit pkgs; };
in
{
  home.packages = [ apps.coverpro apps.spredux apps.openswarm ];
}
