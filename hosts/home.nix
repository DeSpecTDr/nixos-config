{ config, pkgs, lib, user, ... }: {
  imports = [
    ../modules/home/nvim.nix
    ../modules/home/shells.nix
    ../modules/home/gtk.nix
    ../modules/home/librewolf.nix
    ../modules/home/vscodium.nix
  ];

  home.packages = with pkgs; [
    (tor-browser-bundle-bin.override {
      # useHardenedMalloc = false; # it broke again???
    })

    vlc
    mpv

    tdesktop # telegram
    element-desktop # matrix

    keepassxc # password manager
    krita
    inkscape
    libreoffice
    stellarium
    zathura # pdf viewer
    okular # pdf viewer
    audacious # audio player
    joplin-desktop # todo list
    # logseq # todo list
    qbittorrent
    # lapce
    # blender-hip # TODO: just blender on nvidia?
    virt-manager

    rnix-lsp # nix language server
    unstable.nil # another nix language server
    rustup # rust toolchain manager
    # rust-analyzer
    # taplo
    graphviz-nox

    ranger # tui file manager

    hollywood
    # filelight # file size graph
    # ckan # ksp mod manager

    # wezterm # terminal (check out later)
    flameshot
    playerctl

    texlive.combined.scheme-full # latex
    hdparm
    hwinfo
    powertop
    jq
    nixos-option
    p7zip
    unar # universal archive unpacker
    ark
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
    xdg-utils
    atool
    unzip
    killall
    # llvmPackages.bintools
    # umr
    # rocm-smi
    # glxinfo
    # pciutils
    # inxi

    vulkan-tools
    minicom
    # nushell
    xorg.xeyes
    file
    # nodejs
    nmap
    x11docker
    python3
    # catatonit
    # bottles
    compsize
    wireguard-tools
    # dbeaver
    # sqlite
    songrec
    # brave
    kdenlive
    arduino
    usbutils
    # etcher
    android-tools
    inetutils
    # mplayer
    # v4l-utils
    filelight
    # zellij
    # ungoogled-chromium
    psmisc
    # picocom
    # socat
    # ddd
    nix-tree
  ];

  services = {
    # kdeconnect.enable = true;
    gammastep = {
      enable = true;
      temperature = {
        day = 6500;
        night = 2000;
      };
      dawnTime = "6:00-7:45";
      duskTime = "20:35-22:15";
    };
  };

  programs = {
    man.generateCaches = true; # TODO: does this work

    gpg.enable = true;
    # sagemath.enable = true;
    kitty = {
      enable = true;
      # theme = "Gruvbox Dark";
      # font.name = "Fura Mono Regular Nerd Font Complete";
      # font.name = "Fira Code Regular Nerd Font Complete";
      font.name = "Hack Nerd Font";
      settings = {
        background_opacity = "0.8";
      };
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };

    # dircolors.enable = true;

    nix-index.enable = true; # nix-index, nix-locate

    obs-studio.enable = true;

    ncmpcpp.enable = true; # TODO: add mpc

    git = {
      enable = true;
      userName = "DeSpecTDr";
      userEmail = "73001251+DeSpecTDr@users.noreply.github.com"; # TODO: use real email
      extraConfig = {
        init.defaultBranch = "main";
      }; # TODO: add gpg key
    };

    fzf.enable = true;
    zoxide.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      # download = "$HOME/downloads";
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "22.11";
  };

  home.file."homepackages.txt".text = builtins.concatStringsSep "\n" config.home.packages;

  programs.home-manager.enable = true;
}
