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

  virtualisation.libvirtd.enable = true; # TODO: disable on startup 

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

  # services.journald.console = "/dev/tty12";
  # hardware.ksm.enable = true;
  # services.smartd = {
  #   enable = true;
  #   # Monitor all devices connected to the machine at the time it's being started
  #   autodetect = true;
  #   notifications = {
  #     x11.enable = if config.services.xserver.enable then true else false;
  #     wall.enable = true; # send wall notifications to all users
  #   };
  # };
  # Enable entropy daemon which refills /dev/random when low
  # services.haveged.enable = true;
  # Add the NixOS Manual on virtual console 8
  # services.nixosManual.showManual = true;
  # services.gnome3.gnome-keyring.enable = true;
  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };
  # programs.iftop.enable = true;
  # programs.iotop.enable = true;
  # programs.mtr.enable = true;

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

  tlp.enable = true; # conflicts with powerManagement?
  # services.thermald.enable = true;
  services.upower.enable = true; # for safely hibernating when 2 mins of charge are left
}
