{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/greetd.nix
  ];

  networking = {
    hostName = "laptop";
    # interfaces = {
    #   enp3s0.useDHCP = true;
    #   wlp4s0.useDHCP = true;
    # };
  };

  boot = {
    loader = {
      timeout = 1; # TODO: make grub hidden by default
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        # gfxmodeEfi = "1366x768"; # TODO: still lags
        configurationLimit = 10;
        efiInstallAsRemovable = true; # install to hardcoded EFI location
      };
      efi = {
        canTouchEfiVariables = false; # TODO: false?
        # waiting for grub 2.11 for argon2 support
        # efiSysMountPoint = "/efi";
      };
    };
    initrd.systemd.enable = true;
    plymouth.enable = true;
  };

  # services.geoclue2.enable = true;

  zramSwap = {
    enable = true;
  };

  xdg.portal.wlr.enable = true;

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # TODO: move this to sway (somehow)
  # TODO: check if it works without it
  security.pam.services."swaylock".text = "auth include login";

  # tlp.enable = true;
  # powerManagement.powertop.enable = true;
  # services.upower.enable = true; # for safely hibernating when 2 mins of charge are left
}
