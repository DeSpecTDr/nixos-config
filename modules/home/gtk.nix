{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "lxapp" "GDK_BACKEND=x11 ${pkgs.lxappearance}/bin/lxappearance") # theme viewer
    at-spi2-core # idk what is it
    colloid-gtk-theme
    whitesur-icon-theme
  ];

  home.sessionVariables = {
    GTK_USE_PORTAL = 1; # ??? TODO: https://github.com/NixOS/nixpkgs/pull/179204
  };

  # https://libredd.it/r/NixOS/comments/nxnswt/cant_change_themes_on_wayland
  gtk = {
    enable = true;
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };
    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
    };
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    }; # TODO: fix cursor
    # iconTheme = {
    #   name = "Papirus-Dark-Maia"; # Candy and Tela also look good
    #   package = pkgs.papirus-maia-icon-theme;
    # };
    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    # };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };
  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     ...
  #   };
  # };
  # qt = { # TODO: test with an actual QT app
  #   enable = true;
  #   platformTheme = "gtk";
  # };
}
