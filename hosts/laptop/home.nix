{ config, pkgs, lib, ... }: {
  imports = [
    ../../modules/home/sway.nix
    # ../../modules/home/emacs.nix
  ];

  home.packages = with pkgs; [
    firefox-wayland
    thunderbird-wayland # -wayland???
  ];
  
  programs.librewolf.package = pkgs.librewolf-wayland;
}
