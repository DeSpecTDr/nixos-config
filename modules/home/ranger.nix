{pkgs, ...}: {
  home.packages = with pkgs; [
    ranger # tui file manager
  ];

  xdg.configFile."ranger/rc.conf".text = ''
    set preview_images_method kitty
  '';
}
