{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ./modules/home/sway.nix
  ];

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

    inputs.rnix-lsp.defaultPackage.${pkgs.system}
    unstable.hollywood
  ];

  services = {
    emacs.enable = true;
  };


  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
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
        # TODO: add latex workshop, direnv
      ];
    };

    fish = {
      enable = true;
      shellAliases = {
        nixupd = "nix flake update ~/nixos";
        nixreb = "sudo nixos-rebuild switch --flake ~/nixos";
        e = "nvim ";
        se = "EDITOR=nvim sudo -e ";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = false; # enabled in oh-my-zsh
      # initExtra = ''
      #   test -f ~/.dir_colors && eval $(dircolors ~/.dir_colors)
      # '';
      # shellAliases = {
      #   ne = "nix-env";
      #   ni = "nix-env -iA";
      #   no = "nixops";
      #   ns = "nix-shell --pure";
      #   please = "sudo";
      # };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "systemd" "rsync" "kubectl" ];
        theme = "terminalparty";
      };
    };

    nix-index.enable = true; # nix-index, nix-locate

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
      # TODO set editor for sudo or use emacs+doas
    };

    doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
    };

    fzf.enable = true;
    zoxide.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  xdg.enable = true;

  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
  };

  programs.home-manager.enable = true;
}
