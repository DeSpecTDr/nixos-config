{ config, pkgs, lib, inputs, user, ... }: {
  imports = [
    ../modules/pipewire.nix
    ../modules/printer.nix
    ../modules/syncthing.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ]; # for external hdd

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
    kernelPackages = pkgs.linuxPackages_xanmod; # zen or lqx or xanmod_latest or xanmod_tt?
    # extraModulePackages = with config.boot.kernelPackages; [ wireguard ];
    kernel.sysctl = { "vm.swappiness" = 1; };
    tmpOnTmpfs = true;
  };

  networking = {
    networkmanager.enable = true;
    # useDHCP = false; networkmanager manages dhcp itself
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
    extraGroups = [ "networkmanager" "wheel" "video" "libvirtd" ];
    initialPassword = "notmyrealpassword";
  };

  nix = {
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
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # fix nix-index
    registry.nixpkgs.flake = inputs.nixpkgs; # do this with other inputs? flake-utils?
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraMono"
          "FiraCode"
          "Hack"
          "Ubuntu"
        ];
      })
    ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # systemd.services."<service-name>".wantedBy = lib.mkForce [ ];
  services = {
    flatpak.enable = true; # flatseal, steam, discord, (DRI_PRIME=1)
    udisks2.enable = true; # TODO: automount usb drives
    dbus.enable = true;
    # fwupd.enable = true; # firmware updates
    # openssh.enable = true;
    logind.extraConfig = ''
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
      # let systemd handle it
      LidSwitchIgnoreInhibited=no
    '';
  };

  virtualisation.libvirtd.enable = true; # TODO: disable on startup?

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs = {
    fish.enable = true; # fish autocompletions
    dconf.enable = true; # for gtk themes in home-manager
    light.enable = true; # brightness
    gnome-disks.enable = true; # for disk benchmarking
    kdeconnect.enable = true;
  };

  security = {
    # polkit.enable = true;
    # doas = {
    #   enable = true;
    #   extraRules = [{
    #     groups = [ "wheel" ];
    #     persist = true;
    #   }];
    # };
    sudo = {
      # enable = false;
      package = pkgs.sudo.override {
        withInsults = true;
      };
      extraConfig = "Defaults insults";
    };
  };

  environment.etc."systempackages.txt".text = builtins.concatStringsSep "\n" config.environment.systemPackages;

  # config.users.users.${user}.packages;
  # let
  #   packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
  #   sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
  #   formatted = builtins.concatStringsSep "\n" sortedUnique;
  # in
  # formatted;

  system.stateVersion = "22.05";
}
