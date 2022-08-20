{ config, pkgs, lib, user, ... }: {
  imports = [
    ../modules/home/nvim.nix
    ../modules/home/shells.nix
    ../modules/home/gtk.nix
    ../modules/home/librewolf.nix
  ];

  home.packages = with pkgs; [
    (tor-browser-bundle-bin.override {
      useHardenedMalloc = false;
    })

    vlc
    mpv

    tdesktop # telegram

    keepassxc # password manager
    krita
    libreoffice
    stellarium
    # zathura # pdf viewer (broken) change to okular?
    okular # pdf viewer
    audacious # audio player
    joplin-desktop # todo list

    rnix-lsp # nix language server
    # nil # another nix language server
    rustup # rust toolchain manager

    ranger # tui file manager
    xfce.thunar # gui file manager

    # unstable.hollywood # hacker terminal
    # filelight # file size graph
    # ckan # ksp mod manager
  ];

  services = {
    kdeconnect.enable = true;
  };

  programs = {
    qutebrowser.enable = true;

    gpg.enable = true;

    alacritty.enable = true;

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        ms-toolsai.jupyter
        ms-python.python

        matklad.rust-analyzer
        vadimcn.vscode-lldb
        serayuzgur.crates
        tamasfe.even-better-toml

        jnoortheen.nix-ide
        # TODO: add mkhl.direnv

        james-yu.latex-workshop
        usernamehw.errorlens
        asvetliakov.vscode-neovim
      ];
      # userSettings = {
      #   "nix.enableLanguageServer" = true;
      #   "editor.formatOnSave" = true;
      #   "files.autoSave" = "afterDelay";
      #   "vscode-neovim.neovimExecutablePaths.linux" = "nvim";
      #   "vscode-neovim.mouseSelectionStartVisualMode" = true;
      #   "editor.acceptSuggestionOnEnter" = "off";
      # };
    };

    # dircolors.enable = true;

    nix-index.enable = true; # nix-index, nix-locate

    obs-studio = {
      enable = true;
      # Works without that?
      # plugins = with obs-studio-plugins; [
      #   wlrobs
      #   obs-pipewire-audio-capture
      # ];
    };

    ncmpcpp.enable = true; # TODO: add mpc

    git = {
      enable = true;
      userName = "DeSpecTDr";
      userEmail = "73001251+DeSpecTDr@users.noreply.github.com";
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
    stateVersion = "22.05";
  };

  programs.home-manager.enable = true;
}
