{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "desktop";
}
