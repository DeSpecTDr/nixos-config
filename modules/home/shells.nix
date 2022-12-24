{ config, pkgs, lib, ... }: {
  programs = {
    bash.enable = true; # so home.sessionVariables work

    fish = {
      enable = true;
      shellInit = ''
        set fish_greeting # Remove welcome message
      '';
    };

    # zsh = {
    #   enable = true;
    #   enableCompletion = false; # enabled in oh-my-zsh
    #   oh-my-zsh = {
    #     enable = true;
    #     plugins = [ "git" "systemd" ];
    #   };
    # };
  };

  home = {
    shellAliases = {
      nixupd = "nix flake update ~/nixos";
      nixreb = "sudo nixos-rebuild switch -v --flake ~/nixos";
      nixbuild = "cd ~/nixos && nixos-rebuild build --flake . && ${pkgs.nvd}/bin/nvd diff /run/current-system result";
      nixswitch = "sudo ~/nixos/result/bin/switch-to-configuration switch";
      e = "nvim ";
      # se = "sudo -e ";
      log1 = "journalctl -b -x -p 5";
      log2 = "systemctl --failed";
      packages = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq";
      # nixos-option environment.systemPackages | head -2 | tail -1 | sed -e 's/ /\n/g' | cut -d- -f2- | sort | uniq
    };
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim"; # is this nessesary?
      SYSTEMD_LESS = "FRXMK"; # TODO make logs start from the end?
    };
  };
}
