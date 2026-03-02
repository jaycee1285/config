{ config, pkgs, ... }:
{
  users.users.john = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
    packages = with pkgs; [
    ];
  };

  # Allow vmtouch to lock up to 8 GB in page cache (dev-preload)
  security.pam.loginLimits = [
    { domain = "john"; type = "soft"; item = "memlock"; value = "8388608"; }
    { domain = "john"; type = "hard"; item = "memlock"; value = "8388608"; }
  ];
}
