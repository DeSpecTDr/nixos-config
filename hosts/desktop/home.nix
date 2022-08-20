{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    polymc # minecraft
  ];

  # xsession.windowManager.i3.enable = true;
}
