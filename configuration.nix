{ config, pkgs, lib, ... }: {
  imports =
    [
      ./hardware.nix
      ./modules/pipewire.nix
      ./modules/greetd.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernel.sysctl = { "vm.swappiness" = 1; };
    loader = {
      timeout = 1;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1024x768"; # TODO: still lags
        configurationLimit = 20;
      };
      efi = {
        canTouchEfiVariables = true; # TODO: false?
        # when grub gets luks2 support
        # efiSysMountPoint = "/boot/efi";
      };
    };
    tmpOnTmpfs = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = false; # TODO: check if networkmanager sets dhcp itself
    # interfaces = {
    #   enp3s0.useDHCP = true;
    #   wlp4s0.useDHCP = true;
    # };
  };

  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.utf8";
    extraLocaleSettings.LC_TIME = "en_DK.UTF-8"; # ISO-8601 time
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # services.printing.drivers = [ pkgs.gutenprint ];

  users.users.user = {
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
    # autoUpgrade = {
    #   enable = true;
    #   flake = "~/nixos";
    #   flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    # };
  };

  programs.fish.enable = true; # fish autocompletions

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      nerdfonts # (nerdfonts.override { fonts = [ "Iosevka" "Meslo" ]; })
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
  ];

  # enable flatpak for steam
  services.flatpak.enable = true;

  # TODO: move this to home-manager and enable hardware.opengl!
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  # Brightness
  programs.light.enable = true;

  security.sudo = {
    package = pkgs.sudo.override {
      withInsults = true;
    };
    extraConfig = "Defaults insults";
  };

  # TODO: move this to sway (somehow)
  security.pam.services."swaylock".text = "auth include login";

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
