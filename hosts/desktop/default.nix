{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  networking = {
    hostName = "desktop";
    # interfaces = {
    #   eno1.useDHCP = true;
    #   wlp5s0.useDHCP = true;
    # };
  };

  # services.yggdrasil = {
  #   enable = true;
  #   persistentKeys = true;
  #   settings = {
  #     IfName = "ygg0";
  #   };
  # };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      timeout = 1;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        configurationLimit = 10;
        efiInstallAsRemovable = true; # install to hardcoded EFI location
      };
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/efi";
      };
    };
  };

  nixpkgs.config.allowUnfree = true; # TODO: only whitelist nvidia driver

  services.xserver = {
    enable = true;
    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";
    # desktopManager = {
    #   xfce.enable = true;
    # };
    windowManager.i3.enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };
    videoDrivers = ["nvidia"];
  };

  # environment.sessionVariables = {
  #   WLR_DRM_NO_ATOMIC = "1";
  #   WLR_NO_HARDWARE_CURSORS = "1";
  #   LIBVA_DRIVER_NAME = "nvidia";
  #   # MOZ_DISABLE_RDD_SANDBOX = "1";
  #   EGL_PLATFORM = "wayland";
  # };

  hardware = {
    # opengl.enable = true;
    opengl.extraPackages = [pkgs.nvidia-vaapi-driver];
    # nvidia = {
    #   # open = true;
    #   modesetting.enable = true;
    #   # nvidiaSettings = false;
    #   # package = nvidiaPkg;
    #   powerManagement.enable = false;
    # };
  };
}
