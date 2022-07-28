{ config, pkgs, lib, nix-doom-emacs, ... }:

{
  imports = [
    ./modules/home/sway.nix
  ];
  home.packages = with pkgs; [
    ckan # ksp mod manager
    thunderbird-wayland
    vlc
    mpv
    element-desktop-wayland
    keepassxc
    alacritty
    xfce.thunar
    krita
    stellarium
    libreoffice
    tdesktop
    zathura # pdf viewer
    filelight # file size graph
    rnix-lsp # nix lsp
    #rnix-lsp.defaultPackage.x86_64-linux
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
        arrterian.nix-env-selector
        jnoortheen.nix-ide
        ms-python.python
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

    nix-index.enable = true; # TODO: is it really needed?

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
  };

  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
  };

  programs.home-manager.enable = true;
}
