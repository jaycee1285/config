{ config, pkgs, ... }:
{
home.file.".config/fuzzel" = {
  source = ./fuzzel;
  target = ".config/fuzzel";
  recursive = true;
  onChange = "true"; # always update
};
}
