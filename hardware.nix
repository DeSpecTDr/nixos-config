{
  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices."cryptlvm" = {
        device = "/dev/disk/by-uuid/6e0be3f0-43a7-41e5-8f19-ec00981f014a";
        allowDiscards = true;
      };
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/7CC2-B106";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-uuid/5b7cad85-c8eb-47e4-8404-a318a23b1454";
      fsType = "btrfs";
      options = [ "subvol=@" "compress-force=zstd:3" "noatime" "discard=async" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/5b7cad85-c8eb-47e4-8404-a318a23b1454";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress-force=zstd:3" "noatime" "discard=async" ];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/5b7cad85-c8eb-47e4-8404-a318a23b1454";
      fsType = "btrfs";
      options = [ "subvol=@log" "compress-force=zstd:3" "noatime" "discard=async" ];
    }; # FIXME: make nodatacow???

    "/nix" = {
      device = "/dev/disk/by-uuid/5b7cad85-c8eb-47e4-8404-a318a23b1454";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress-force=zstd:3" "noatime" "discard=async" ];
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/39448f34-d8c3-40e2-ab83-23d880489d62"; }];

  # powerManagement.cpuFreqGovernor = "powersave"; or use power manager?
  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true; # TODO: disable and check what fails
  };
}
