{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    systemdTarget = "labwc-session.target";


    profiles = {
      # ── When the external monitor is attached ────────────────────────────────
      docked = {
        outputs = [
          # External monitor (left)
          {
            criteria = "DP-3";              # exact name from `wlr-randr`
            mode     = "1920x1080@60Hz";    # or just "1920x1080"
            position = "0,0";
          }

          # Laptop panel (right)
          {
            criteria = "eDP-1";
            mode     = "1920x1080@60Hz";
            position = "1920,0";            # x == width of DP-3
          }
        ];
      };

      # ── Fallback when you’re on battery ──────────────────────────────────────
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
            # mode omitted → keep whatever is current/native
          }
        ];
      };
    };
  };
}
