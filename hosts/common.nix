{ config, pkgs, lib, inputs, user, ... }: {
  imports = [
    ../modules/pipewire.nix
    ../modules/printer.nix
  ];

  # nix search nixpkgs wget
  environment.systemPackages = with pkgs; [
    # tools
    ffmpeg
    wget
    btop
    htop
    neofetch
    ripgrep
    bat
    du-dust
    fd
    smartmontools

    # TODO: add all packages here (but commented out)
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # zen or lqx or xanmod_latest?
    # extraModulePackages = with config.boot.kernelPackages; [ wireguard ];
    kernel.sysctl = { "vm.swappiness" = 1; };
    tmpOnTmpfs = true;
    initrd.systemd.enable = true;
    plymouth.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    # networkmanager manages dhcp itself
    # useDHCP = false;
    # interfaces = {
    #   enp3s0.useDHCP = true;
    #   wlp4s0.useDHCP = true;
    # };
  };

  time.timeZone = "Europe/Moscow";

  i18n = {
    defaultLocale = "en_US.utf8";
    # ISO-8601 time NOTE: date --rfc-3339=seconds
    extraLocaleSettings.LC_TIME = "en_DK.UTF-8";
  };

  # console = {
  #   # font = "Lat2-Terminus16";
  #   font = "JetBrainsMono";
  #   keyMap = "ru";
  #   # useXkbConfig = true;
  # };

  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    initialPassword = "notmyrealpassword";
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      keep-outputs = true;
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs; # do this with other inputs? flake-utils?
  };

  fonts = {
    # enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services = {
    flatpak.enable = true; # flatseal, steam, discord
    udisks2.enable = true; # TODO: automount usb drives
    dbus.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs = {
    fish.enable = true; # fish autocompletions
    dconf.enable = true; # for gtk themes in home-manager
    light.enable = true; # brightness
    gnome-disks.enable = true; # for disk benchmarking
  };

  security.sudo = {
    package = pkgs.sudo.override {
      withInsults = true;
    };
    extraConfig = "Defaults insults";
  };

  # tlp.enable = true;
  # powerManagement.powertop.enable = true;
  # services.upower.enable = true; # for safely hibernating when 2 mins of charge are left

  # services.fwupd.enable = true; # firmware updates (there are none)

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "22.05";
}
