{ config, pkgs, ... }:
{
   service.pulsewire.enable = false;
   services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
   };
}
