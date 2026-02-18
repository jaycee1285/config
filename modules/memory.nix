{ config, ... }:

{
  # Balanced swap: prefer zram, keep a smaller disk swapfile, and low swappiness.
  zramSwap = {
    enable = true;
    memoryPercent = 50; # ~8 GiB on a 16 GiB system
    priority = 100;
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/a395f719-892f-49c9-8b75-50f9399bdf8f";
      priority = 10;
    }
  ];

  boot.kernel.sysctl."vm.swappiness" = 15;
}
