{ pkgs, ... }: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "lxapp" "GDK_BACKEND=x11 ${pkgs.lxappearance}/bin/lxappearance") # theme viewer
    at-spi2-core # idk what is it
    colloid-gtk-theme
  ];

  home.sessionVariables = {
    GTK_USE_PORTAL = 1; # ??? TODO: https://github.com/NixOS/nixpkgs/pull/179204
  };

  # https://libredd.it/r/NixOS/comments/nxnswt/cant_change_themes_on_wayland
  gtk = {
    enable = true;
    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    # iconTheme = {
    #   name = "Papirus-Dark-Maia"; # Candy and Tela also look good
    #   package = pkgs.papirus-maia-icon-theme;
    # };
    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    #   gtk-key-theme-name = "Emacs";
    #   gtk-icon-theme-name = "Papirus-Dark-Maia";
    #   gtk-cursor-theme-name = "capitaine-cursors";
    # };
  };
  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     gtk-key-theme = "Emacs";
  #     cursor-theme = "Capitaine Cursors";
  #   };
  # };
  # xdg.systemDirs.data = [
  #   "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  #   "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  # ];
  # gtk = {
  #   enable = true;
  #   # iconTheme = {
  #   #   name = "";
  #   #   package = pkgs.adwaita-icon-theme;
  #   # };
  #   theme = {
  #     name = "Dracula";
  #     package = pkgs.dracula-theme;
  #   };
  # };
}
