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
  ];

  services = {
    emacs.enable = true;
    kdeconnect.enable = true;
  };

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.unstable.vscode-extensions; [
        ms-toolsai.jupyter
        usernamehw.errorlens
        asvetliakov.vscode-neovim
        matklad.rust-analyzer
        vadimcn.vscode-lldb
        serayuzgur.crates
        tamasfe.even-better-toml
        # arrterian.nix-env-selector
        jnoortheen.nix-ide
        ms-python.python
        james-yu.latex-workshop
        # TODO: add direnv
      ];
      # userSettings = {
      #   "nix.enableLanguageServer" = true;
      #   "editor.formatOnSave" = true;
      #   "files.autoSave" = "afterDelay";
      #   "vscode-neovim.neovimExecutablePaths.linux" = "nvim";
      #   "vscode-neovim.mouseSelectionStartVisualMode" = true; # broken
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

    neovim = {
      enable = true;
      extraConfig = ''
        set clipboard+=unnamedplus
        " syntax enable
        " filetype plugin indent on
      '';
      plugins = with pkgs.vimPlugins; [
        vim-nix
        {
          plugin = vimtex;
          config = ''
            let g:vimtex_view_method = 'zathura'
            let g:vimtex_compiler_method = 'latexmk'
          '';
        }
      ];
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
}
