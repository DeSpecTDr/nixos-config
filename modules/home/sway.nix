{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    grim
    slurp
    playerctl
    swaylock-effects # check its repository later
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
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+q" = "kill";
          "${mod}+c" = ''exec grim -g "$(slurp)" - | wl-copy'';
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
