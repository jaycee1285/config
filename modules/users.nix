{ config, pkgs, ... }:
{
  users.users.john = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
    packages = with pkgs; [     
    ];
  };
}
