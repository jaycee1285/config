{ config, pkgs, lib, ... }:

let
  # CHANGE THIS to the path you saw from `ls -1 /proc/acpi/button/lid/*/state`
  lidStateFile = "/proc/acpi/button/lid/LID/state";

  # Optional: set to your external output name (e.g., "DP-1") if you want to keep it on when lid closes.
  externalOutput = "DP-1";

lidScript = pkgs.writeShellScript "lid-wlopm-onchange" ''
  set -eu
  f="${lidStateFile}"
  state="$(${pkgs.coreutils}/bin/tr -d ' ' < "$f" | ${pkgs.coreutils}/bin/cut -d: -f2)"

  if [ "$state" = "closed" ]; then
    ${pkgs.wlopm}/bin/wlopm --off "*"
  else
    ${pkgs.wlopm}/bin/wlopm --on "*"
  fi
'';

in
{
  home.packages = [ pkgs.wlopm ];

  systemd.user.services.lid-wlopm = {
    Unit = { Description = "Toggle outputs on lid open/close (wlopm)"; };
    Service = {
      Type = "oneshot";
      ExecStart = lidScript;
    };
  };

  systemd.user.paths.lid-wlopm = {
    Unit = { Description = "Watch lid state changes"; };
    Path = { PathChanged = lidStateFile; };
    Install = { WantedBy = [ "default.target" ]; };
  };
}
