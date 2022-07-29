{ config, pkgs, lib, ... }:
let
  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
in
{
  home.packages = with pkgs; [
    # screenshots
    grim
    slurp

    bemenu # wayland clone of dmenu
    mako # notification system
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    swaybg # wallpapers

    playerctl
    swaylock-effects # check its repository later

    dbus-sway-environment
    #configure-gtk
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme # default gnome cursors TODO
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:alt_shift_toggle";
        };
        "type:touchpad" = {
          # dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          # middle_emulation = "enabled"; default?
        };
      };
      output."*" = { bg = "~/nixos/wallpaper.jpg fill"; };
      terminal = "alacritty";
      menu = "bemenu-run";
      modifier = "Mod4"; # Super
      bindkeysToCode = true;
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+q" = "kill";
          "${mod}+c" = ''exec grim -g "$(slurp)" - | wl-copy -t image/png'';
          # TODO: configure swaylock-effects
          "Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";

          # brightness keys
          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";

          # audio keys
          "XF86AudioRaiseVolume" = "exec pamixer -i 5";
          "XF86AudioLowerVolume" = "exec pamixer -d 5";
          "XF86AudioMute" = "exec pamixer -t";

          # media keys
          XF86AudioPlay = "exec playerctl play-pause";
          XF86AudioPause = "exec playerctl play-pause";
          XF86AudioNext = "exec playerctl next";
          XF86AudioPrev = "exec playerctl previous";
        };
      bars = [{
        command = "waybar";
        # statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs";
        # statusCommand = "i3status";
        # position = "top";
      }];
    };
    # systemdIntegration = true;
    # extraConfig = ''
    #   exec dbus-sway-environment
    # '';
    #   exec configure-gtk
    # '';
    # TODO: check if this works
    extraSessionCommands = ''
      export NIXOS_OZONE_WL=1
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    #   export XDG_SESSION_TYPE=wayland
    #   export XDG_SESSION_DESKTOP=sway
    #   export XDG_CURRENT_DESKTOP=sway
    # '';
  };

  services = {
    # TODO: lock the screen after 5 minutes
    swayidle = {
      enable = true;
      timeouts = [{
        timeout = 300;
        command = ''swaymsg "output * dpms off"'';
        resumeCommand = ''swaymsg "output * dpms on"'';
      }];
    };
  };


  programs = {
    # i3status = {
    #   enable = true;
    #   modules = {
    #     "volume master" = {
    #       position = 1;
    #       settings = {
    #         format = "♪ %volume";
    #         format_muted = "♪ muted (%volume)";
    #         device = "pulse";
    #       };
    #     };
    #   };
    # };

    waybar = {
      enable = true;
      # systemd.enable = true;
    };
  };
}
