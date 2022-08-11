{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    librewolf # TODO: add as an option when it gets backported
    polymc # minecraft
  ];
}
