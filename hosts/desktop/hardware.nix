{
  boot = {
    kernelModules = ["kvm-intel"];
    initrd = {
      availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["dm-snapshot"];
    };
  };

  fileSystems = {
    "/efi" = {
      device = "/dev/disk/by-uuid/6E02-C1B4";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-uuid/687d3196-2b02-435b-b29c-94505a69cec7";
      fsType = "btrfs";
      options = ["subvol=@" "compress-force=zstd:3" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/687d3196-2b02-435b-b29c-94505a69cec7";
      fsType = "btrfs";
      options = ["subvol=@home" "compress-force=zstd:3" "noatime"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/687d3196-2b02-435b-b29c-94505a69cec7";
      fsType = "btrfs";
      options = ["subvol=@log" "compress-force=zstd:3" "noatime"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/687d3196-2b02-435b-b29c-94505a69cec7";
      fsType = "btrfs";
      options = ["subvol=@nix" "compress-force=zstd:3" "noatime"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/687d3196-2b02-435b-b29c-94505a69cec7";
      fsType = "btrfs";
      options = ["subvol=@persist" "compress-force=zstd:3" "noatime"];
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/15bc2ce3-ce84-4be7-8b38-17a7a638f5f1";}];

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
}
