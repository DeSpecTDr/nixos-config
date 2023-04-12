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
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # zen or lqx or xanmod_latest or xanmod_tt?
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
      # use systemd-boot, but without full-disk encryption?
      systemd-boot = {
        # enable = true;
        editor = false;
      };
      efi = {
        canTouchEfiVariables = false; # TODO: false?
        # waiting for grub 2.11 for argon2 support
        # efiSysMountPoint = "/efi";
      };
    };
    initrd = {
      systemd.enable = true;
      #   preLVMCommands = ''
      #     echo '--- OWNERSHIP NOTICE ---'
      #     echo 'This device is property of .'
      #     echo 'If lost please contact . at .'
      #     echo '--- OWNERSHIP NOTICE ---'
      #   '';
      # };
    };
    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };

  # services.nixosManual.showManual = true;
  # services.gnome3.gnome-keyring.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;
  # programs.iftop.enable = true;
  # programs.iotop.enable = true;
  # programs.mtr.enable = true;

  # services.geoclue2.enable = true;

  zramSwap = {
    enable = true;
  };

  # TODO: find a way to make sway a separate cgroup
  # systemd.oomd = {
  #   enableRootSlice = true;
  #   enableUserServices = true;
  # };

  xdg.portal.wlr.enable = true;

  # hardware.opengl.extraPackages = with pkgs; [
  #   rocm-opencl-icd
  #   rocm-opencl-runtime
  # ];

  # TODO: move this to sway (somehow)
  # TODO: check if it works without it
  security.pam.services."swaylock".text = "auth include login";

  # services.thermald.enable = true;
  services = {
    upower.enable = true; # FIXME: Doesn't work, for safely hibernating when 2 mins of charge are left
    tlp.enable = true; # preserve power
  };
}
