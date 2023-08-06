{
  config,
  pkgs,
  lib,
  user,
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
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        configurationLimit = 10;
        efiInstallAsRemovable = true; # install to hardcoded EFI location
        theme = pkgs.libsForQt5.breeze-grub;
        # set theme=${pkgs.plasma5.breeze-grub}/grub/themes/breeze/theme.txt
        # set theme=($drive1)/@/boot/theme/theme.txt
        # set theme=($drive1)/@/boot/theme/grub/themes/breeze/theme.txt
        extraConfig = ''
          set theme=($drive1)/@/boot/theme/grub/themes/breeze/theme.txt
          if keystatus --shift ; then
            set timeout=-1
          else
            set timeout=0
          fi
        '';
        splashImage = null;
      };
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/efi";
      };
    };
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    # initrd.systemd.enable = true;
  };

  nixpkgs.config.allowUnfree = true; # TODO: only whitelist nvidia driver

  services.xserver = {
    enable = true;
    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";
    # windowManager.i3 = {
    #   enable = true;
    #   package = pkgs.i3-gaps;
    # };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        # noDesktop = true;
        # enableXfwm = false;
      };
      plasma5.enable = true;
    };
    displayManager = {
      sddm.enable = true;
      autoLogin.user = user;
      defaultSession = "plasma";
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
