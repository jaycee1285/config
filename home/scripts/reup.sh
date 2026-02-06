#!/usr/bin/env bash
set -e

CONFIG_DIR="/home/john/repos/config"

echo "Sed or Zed?"
read -r host

case "$host" in
  [Ss]ed) host="Sed" ;;
  [Zz]ed) host="Zed" ;;
  *)
    echo "Invalid choice. Please enter 'Sed' or 'Zed'."
    exit 1
    ;;
esac

cd "$CONFIG_DIR"

echo ":: Updating flake (sudo)..."
sudo nix flake update

echo ":: Updating flake (user)..."
nix flake update

echo ":: Rebuilding NixOS for $host..."
sudo nixos-rebuild switch --flake ".#$host"

echo ":: Deleting old generations..."
sudo nix-env --delete-generations old

echo ":: Collecting garbage..."
sudo nix-collect-garbage

echo ""
echo "Reboot now? (y/n)"
read -r reboot

case "$reboot" in
  [Yy]|[Yy]es)
    sudo reboot
    ;;
  *)
    echo "Done!"
    exit 0
    ;;
esac
