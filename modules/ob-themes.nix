{ pkgs, ob-themes, ... }:

{
  environment.systemPackages = [
    ob-themes  # It's already a package, not a flake
  ];
}
