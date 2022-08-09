{ config, pkgs, lib, inputs, ... }: {
  home.packages = with pkgs; [
    ckan # ksp mod manager
    thunderbird-wayland # -wayland???
    vlc
    mpv
    element-desktop-wayland # -wayland???
    keepassxc
    alacritty
    xfce.thunar
    krita
    stellarium
    libreoffice
    tdesktop # telegram
    zathura # pdf viewer
    filelight # file size graph
    audacious # audio player
    texlive.combined.scheme-full # latex
    joplin-desktop # todo list
    polymc # minecraft

    inputs.rnix-lsp.defaultPackage.${pkgs.system} # latest rnix-lsp
    unstable.hollywood
    at-spi2-core # try deleting later
  ];

  services = {
    emacs.enable = true;
    kdeconnect.enable = true;
  };

  programs = {
    # when it gets backported
    # librewolf = {
    #   enable = true;
    # };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.unstable.vscode-extensions; [
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

    git = {
      enable = true;
      userName = "DeSpecTDr";
      userEmail = "73001251+DeSpecTDr@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    doom-emacs = {
      enable = true;
      doomPrivateDir = ../../doom.d;
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

  xdg.enable = true;

  # TODO: https://libredd.it/r/NixOS/comments/nxnswt/cant_change_themes_on_wayland
  # add at-spi2-core to packages?
  gtk = {
    enable = true;
    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    # iconTheme = {
    #   name = "Papirus-Dark-Maia"; # Candy and Tela also look good
    #   package = pkgs.papirus-maia-icon-theme;
    # };
    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    #   gtk-key-theme-name = "Emacs";
    #   gtk-icon-theme-name = "Papirus-Dark-Maia";
    #   gtk-cursor-theme-name = "capitaine-cursors";
    # };
  };
  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     gtk-key-theme = "Emacs";
  #     cursor-theme = "Capitaine Cursors";
  #   };
  # };
  # xdg.systemDirs.data = [
  #   "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  #   "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  # ];
  # gtk = {
  #   enable = true;
  #   # iconTheme = {
  #   #   name = "";
  #   #   package = pkgs.adwaita-icon-theme;
  #   # };
  #   theme = {
  #     name = "Dracula";
  #     package = pkgs.dracula-theme;
  #   };
  # };
}
