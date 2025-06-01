{ config, pkgs, ... }:

let
  # Declarative unstable channel (if you still need it)
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  # Example: Use as pkgs.unstable.foo in other modules if you want
  # (add more system-wide or pkgs logic here)
  system.stateVersion = "25.05";
}
