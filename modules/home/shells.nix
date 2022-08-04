{ config, pkgs, lib, ... }: {
  programs = {
    fish = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = false; # enabled in oh-my-zsh
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
      nixreb = "sudo nixos-rebuild switch --flake ~/nixos";
      e = "nvim ";
      se = "sudo -e ";
      checksystem = "SYSTEMD_LESS=FRXMK journalctl -b -x -p 5 && systemctl --failed";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
