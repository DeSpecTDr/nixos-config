{ config, pkgs, lib, ... }:
let
  mod = "Mod4";
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock --daemonize --show-failed-attempts --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";
in
{
  home.packages = with pkgs; [
    flameshot # screenshots
    playerctl

    bemenu # wayland clone of dmenu
    mako # notification system
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    swaybg # wallpapers (try making animated?)
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
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          # middle_emulation = "enabled";
        };
      };
      output."*" = { bg = "${../../wallpapers/sombrerogalaxy.jpg} fill"; };
      terminal = "alacritty";
      menu = "bemenu-run";
      modifier = mod;
      bindkeysToCode = true;
      keybindings = lib.mkOptionDefault {
        "${mod}+q" = "kill";
        "${mod}+c" = "exec flameshot gui";
        "Ctrl+Alt+l" = "exec ${swaylock}";

        # brightness keys
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";

        # audio keys
        "XF86AudioRaiseVolume" = "exec pamixer -i 5";
        "XF86AudioLowerVolume" = "exec pamixer -d 5";
        "XF86AudioMute" = "exec pamixer -t";
        "Shift+XF86AudioMute" = "exec pamixer --default-source -t";

        # media keys
        "XF86AudioPlay" = "exec playerctl play-pause";
        # "XF86AudioPause" = "exec playerctl play-pause";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
      };
      bars = [ ];
      startup = [
        { command = "${pkgs.autotiling}/bin/autotiling"; always = true; } # better tiling
      ];
    };
    # systemdIntegration = true;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # doesnt work
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  services = {
    swayidle = {
      enable = true;
      timeouts = [
        { timeout = 300; command = "${swaylock} --grace 5"; }
        {
          timeout = 360;
          command = ''swaymsg "output * dpms off"'';
          resumeCommand = ''swaymsg "output * dpms on"'';
        }
      ];
      events = [{ event = "before-sleep"; command = swaylock; }];
    };
  };


  programs = {
    waybar = {
      # TODO: make smaller
      enable = true;
      # systemd.enable = true; # TODO systemd ~8-10 sec
    };
  };
}
