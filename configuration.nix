{ config, pkgs, lib, ... }:

let
  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/pipewire.nix
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
        # gfxmodeEfi = "1080x768"; # TODO: set actual resolution
        configurationLimit = 20;
      };
      efi = {
        canTouchEfiVariables = true; # TODO: false?
        # when grub gets luks2 support
        # efiSysMountPoint = "/boot/efi";
      };
    };
    tmpOnTmpfs = true; # TODO: umount and clear
    # plymouth.enable = true;
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

  services = {
    greetd = {
      enable = true;
      vt = 7;
      settings = rec {
        initial_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
          user = "user";
        };
        default_session = initial_session;
      };
    };
    # xserver = {
    #   enable = true;
    #   layout = "us";
    #   # displayManager.lightdm.enable = false;???
    #   desktopManager.xterm.enable = false;
    # };
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
    # autoUpgrade = {
    #   enable = true;
    #   flake = "~/nixos";
    #   flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    # };
  };

  programs.fish.enable = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      nerdfonts # (nerdfonts.override { fonts = [ "Iosevka" "Meslo" ]; })
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # sway
    #dbus-sway-environment
    #configure-gtk
    wayland
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme # default gnome cursors
    swaylock
    swayidle
    swaybg
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer
    pulseaudio # for pactl

    # tools
    ffmpeg
    wget
    btop
    htop
    neofetch
    ripgrep
    exa
    bat
    du-dust
    #fzf
    fd
    smartmontools

    # TODO: move this to home.nix
    firefox-wayland
    texlive.combined.scheme-full
  ];

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

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    NIXOS_OZONE_WL = "1";
  };

  # Brightness
  programs.light.enable = true;

  security.sudo = {
    package = pkgs.sudo.override {
      withInsults = true;
    };
    extraConfig = "Defaults insults";
  };

  security.pam.services.swaylock = {
    text = "auth include login";
  };

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
