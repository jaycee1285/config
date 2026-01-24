{ config, pkgs, ... }:

  # Common “file manager integration” pieces
  services.gvfs.enable = true;
  services.tumbler.enable = true;   # thumbnails (nice-to-have)
  services.udisks2.enable = true;   # automount support
  programs.dconf.enable = true;     # Nemo settings via gsettings
}
