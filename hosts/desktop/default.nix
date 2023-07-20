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
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        # noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce+i3";
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
