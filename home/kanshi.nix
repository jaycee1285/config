# home-manager module (≈ same keys exist under services.kanshi in system config)
{ pkgs, ... }:

{
  services.kanshi = {
    enable = true;

    profiles = [
      ## Profile when the external monitor is present
      {
        name = "docked";
        outputs = [
          # External DP-3 goes on the left
          {
            criteria = "DP-3";          # use the exact name from `wlr-randr`
            mode     = "1920x1080@60Hz"; # or just "1920x1080" if you don’t care
            position = "0,0";
          }
          # Laptop panel stays on the right
          {
            criteria = "eDP-1";
            mode     = "1920x1080@60Hz";
            position = "1920,0";         # width of DP-3, y=0
          }
        ];
      }

      ## Fallback when you’re on battery with no external monitor
      {
        name = "undocked";
        outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
            # mode optional—kanshi will keep the current native mode
          }
        ];
      }
    ];
  };
}
