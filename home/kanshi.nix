{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    systemdTarget = "labwc-session.target";

    settings = [
      # ── When the external monitor is attached ────────────────────────────────
      {
        profile.name = "docked";
        profile.outputs = [
          # External monitor (left)
          {
            criteria = "DP-3";              # exact name from `wlr-randr`
            mode     = "1920x1080@60Hz";
            position = "0,0";
          }
          # Laptop panel (right)
          {
            criteria = "eDP-1";
            mode     = "1920x1080@60Hz";
            position = "1920,0";            # x == width of DP-3
          }
        ];
      }

      # ── Fallback when you're on battery ──────────────────────────────────────
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
          }
        ];
      }
    ];
  };
}
