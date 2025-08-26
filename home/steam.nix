{ config, pkgs, ... }:
{
programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    extraPackages = with pkgs; [
       kdePackages.breeze
    ];
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    protontricks.enable = true;
  };
}