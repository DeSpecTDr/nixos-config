{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/syncthing.nix
  ];

  networking = {
    hostName = "desktop";
    # interfaces = {
    #   eno1.useDHCP = true;
    #   wlp5s0.useDHCP = true;
    # };
  };

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    settings = {
      Peers = [
        "tls://ygg.averyan.ru:8362"
      ];
      # IfName = "ygg0";
    };
  };

  boot.loader = {
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

  nixpkgs.config.allowUnfree = true; # TODO: only whitelist nvidia driver

  services.xserver = {
    enable = true;
    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";
    desktopManager = {
      xfce.enable = true;
    };
    videoDrivers = [ "nvidia" ];
  };
}
