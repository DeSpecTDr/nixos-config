{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.writeShellScriptBin "lxappearance" "GDK_BACKEND=x11 ${pkgs.lxappearance}/bin/lxappearance") # theme viewer
  ];

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
      # name = "gruvbox-dark";
      # package = pkgs.gruvbox-dark-gtk;
      # name = "Colloid-Dark";
      # package = pkgs.colloid-gtk-theme;
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      # name = "WhiteSur-dark";
      # package = pkgs.whitesur-icon-theme;
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };

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
  #     gtk-application-prefer-dark-theme = true;
  #   };
  # };
  # qt = {
  #   enable = true;
  #   platformTheme = "gnome"; # FIXME
  #   style = {
  #     name = "adwaita-dark";
  #     package = pkgs.adwaita-qt;
  #   };
  # };
}
