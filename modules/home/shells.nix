{ config, pkgs, lib, ... }: {
  programs = {
    fish = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = false; # enabled in oh-my-zsh or is it?
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "systemd" "rsync" "kubectl" ];
        theme = "terminalparty";
      };
    };
  };

  home = {
    shellAliases = {
      nixupd = "nix flake update ~/nixos";
      nixreb = "sudo nixos-rebuild switch -v --flake ~/nixos";
      e = "nvim ";
      se = "sudo -e ";
      checksystem = "journalctl -b -x -p 5 && systemctl --failed";
    };
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim"; # is this nessesary?
      SYSTEMD_LESS = "FRXMK";
    };
  };
}
