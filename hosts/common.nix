{
  config,
  pkgs,
  lib,
  inputs,
  user,
  ...
}: {
  imports = [
    ../modules/pipewire.nix
    ../modules/printer.nix
    ../modules/syncthing.nix
    ../modules/thunar.nix
  ];

  boot.supportedFilesystems = ["ntfs"]; # for external hdd

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "cnijfilter2"
    ];

  # environment.systemPackages = with pkgs; [ ];

  boot = {
    kernel.sysctl = {"vm.swappiness" = 1;};
    tmp.useTmpfs = true;
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
    extraGroups = ["networkmanager" "wheel" "video" "libvirtd" "dialout" "adbusers"];
    initialPassword = "notmyrealpassword";
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      keep-outputs = true;
      auto-optimise-store = true;
      keep-going = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    nixPath = ["nixpkgs=${inputs.nixpkgs}"]; # fix nix-index
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

  systemd.services.sshd.wantedBy = lib.mkForce [];
  services = {
    gnome.gnome-keyring.enable = true; # switch to keepassxc secret service?
    flatpak.enable = true; # flatseal, steam, discord, (DRI_PRIME=1)
    dbus.enable = true;
    # fwupd.enable = true; # firmware updates
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      # startWhenNeeded = true;
    };
    logind.extraConfig = ''
      HandlePowerKey=ignore
      LidSwitchIgnoreInhibited=no
    '';
  };

  virtualisation = {
    libvirtd.enable = true; # TODO: disable on startup?
    podman.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  programs = {
    fish.enable = true; # fish autocompletions
    dconf.enable = true; # for gtk themes in home-manager
    light.enable = true; # brightness
    gnome-disks.enable = true; # for disk benchmarking
    kdeconnect.enable = true;
    seahorse.enable = true;
    adb.enable = true;
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

  powerManagement.cpuFreqGovernor = "schedutil"; # a good default for now

  documentation.man.generateCaches = true; # for autocompletion
  # environment.pathsToLink = [
  #   # "/share/zsh"
  #   "/share/fish"
  # ];

  environment.etc."systempackages.txt".text = builtins.concatStringsSep "\n" config.environment.systemPackages;

  # config.users.users.${user}.packages;
  # let
  #   packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
  #   sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
  #   formatted = builtins.concatStringsSep "\n" sortedUnique;
  # in
  # formatted;

  system.stateVersion = "23.05";
}
