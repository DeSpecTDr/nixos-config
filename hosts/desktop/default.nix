{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "desktop";

  boot.loader = {
    timeout = 1;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 10;
    };
    efi = {
      canTouchEfiVariables = false; # TODO: false?
      efiSysMountPoint = "/efi";
    };
  };

  services.xserver = {
    enable = true;
    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";
  };
}
