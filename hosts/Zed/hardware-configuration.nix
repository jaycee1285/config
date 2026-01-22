# PLACEHOLDER - Replace with output from nixos-generate-config
# Run on target machine: nixos-generate-config --show-hardware-config > hardware-configuration.nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # TODO: Replace these with values from your target machine
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];  # Use "kvm-amd" for AMD CPUs
  boot.extraModulePackages = [ ];

  # TODO: Replace with your actual disk UUIDs
  # Find with: blkid or lsblk -f
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-ROOT-UUID";
      fsType = "ext4";  # Or btrfs, xfs, etc.
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-BOOT-UUID";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # For Intel CPU:
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # For AMD CPU, comment above and uncomment:
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
