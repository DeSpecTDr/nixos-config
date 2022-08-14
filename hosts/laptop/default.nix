{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/greetd.nix
  ];

  networking.hostName = "laptop";

  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;
  boot.loader = {
    timeout = 1; # TODO: make grub hidden by default
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      # gfxmodeEfi = "1366x768"; # TODO: still lags
      configurationLimit = 10;
    };
    efi = {
      canTouchEfiVariables = true; # TODO: false?
      # waiting for grub 2.11 for argon2 support
      # efiSysMountPoint = "/boot/efi";
    };
  };

  xdg.portal.wlr.enable = true;

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # TODO: move this to sway (somehow)
  # TODO: check if it works without it
  security.pam.services."swaylock".text = "auth include login";
}
