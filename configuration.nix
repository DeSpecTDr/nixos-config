{ config, pkgs, lib, inputs, ... }: {
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

  i18n = {
    defaultLocale = "en_US.utf8";
    # ISO-8601 time NOTE: date --rfc-3339=seconds
    extraLocaleSettings.LC_TIME = "en_DK.UTF-8";
  };

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
    registry.nixpkgs.flake = inputs.nixpkgs; # set nixpkgs registry to global config
  };

  programs.fish.enable = true; # fish autocompletions

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      nerdfonts # (nerdfonts.override { fonts = [ "Iosevka" "Meslo" ]; })
    ];
  };

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
  ];

  # flatpaks: flatseal, steam
  services.flatpak.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };

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

  # services.tlp.enable = true; # power manager
  # powerManagement.powertop.enable = true;

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
