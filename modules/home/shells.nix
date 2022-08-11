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
        plugins = [ "git" "systemd" ];
      };
    };
  };

  home = {
    shellAliases = {
      nixupd = "nix flake update ~/nixos";
      nixreb = "sudo nixos-rebuild switch -v --flake ~/nixos";
      e = "nvim ";
      se = "sudo -e ";
      log1 = "journalctl -b -x -p 5";
      log2 = "systemctl --failed";
    };
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim"; # is this nessesary?
      SYSTEMD_LESS = "FRXMK"; # TODO make logs start from the end?
    };
  };
}
