{ config, pkgs, lib, inputs, user, ... }: {
  imports = [
    ../modules/pipewire.nix
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

    # TODO: move this to home.nix
    firefox-wayland

    # TODO: add all packages here (but commented out)
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # zen or lqx or xanmod_latest?
    # extraModulePackages = with config.boot.kernelPackages; [ wireguard ];
    kernel.sysctl = { "vm.swappiness" = 1; };
    loader = {
      timeout = 1;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        # gfxmodeEfi = "1366x768"; # TODO: still lags
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = false; # TODO: false?
        # waiting for grub 2.11 for argon2 support
        # efiSysMountPoint = "/boot/efi";
      };
    };
    tmpOnTmpfs = true;
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

  # Enable CUPS to print documents.
  # services.printing = {
  #   enable = true;
  #   drivers = [ pkgs.gutenprint ];
  # };

  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    initialPassword = "notmyrealpassword";
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
    '';
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs; # TODO: do this with every input
  };

  programs.fish.enable = true; # fish autocompletions

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      nerdfonts # (nerdfonts.override { fonts = [ "Iosevka" "Meslo" ]; })
    ];
  };

  # flatpaks: flatseal, steam, discord
  services.flatpak.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    # TODO: move to laptop
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  programs.dconf.enable = true; # for gtk themes in home-manager

  # Brightness
  programs.light.enable = true;

  security.sudo = {
    package = pkgs.sudo.override {
      withInsults = true;
    };
    extraConfig = "Defaults insults";
  };

  # services.tlp.enable = true; # power manager
  # powerManagement.powertop.enable = true;
  # services.upower.enable = true; # for safely hibernating when 2 mins of charge are left

  # services.fwupd.enable = true; # firmware updates (there are none)

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "22.05";
}
