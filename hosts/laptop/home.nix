{ config, pkgs, lib, ... }: {
  imports = [
    ../../modules/home/sway.nix
  ];

  home.packages = with pkgs; [
    firefox-wayland # TODO: switch to librewolf
    texlive.combined.scheme-full # latex
    element-desktop-wayland # -wayland???
    thunderbird-wayland # -wayland???
  ];

  services.emacs.enable = true;
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ../../doom.d;
  };
}
