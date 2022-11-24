{ config, pkgs, lib, ... }: {
  imports = [
    ../../modules/home/sway.nix
    # ../../modules/home/emacs.nix
  ];

  home.packages = with pkgs; [
    firefox-wayland # TODO: switch to librewolf
    thunderbird-wayland # -wayland???
  ];
  
  programs.librewolf.package = pkgs.librewolf-wayland;
}
