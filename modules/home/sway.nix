{ config, pkgs, lib, ... }:
let
  mod = "Mod4";
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
in
{
  home.packages = with pkgs; [
    bemenu # wayland clone of dmenu
    mako # notification system
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    swaybg # wallpapers (try making animated?)
    swaylock-effects # check its repository later
  ];

  # TODO: mako config

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:alt_shift_toggle";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "disabled";
        };
      };
      output."*".bg = "${../../wallpapers/sombrerogalaxy.jpg} fill";
      terminal = "kitty";
      menu = "bemenu-run";
      modifier = mod;
      bindkeysToCode = true;
      keybindings = lib.mkOptionDefault {
        "${mod}+q" = "kill";
        "${mod}+c" = "exec flameshot gui";
        "Ctrl+Alt+l" = "exec ${swaylock}";

        # gaps
        "${mod}+Ctrl+j" = "gaps inner all minus 5";
        "${mod}+Ctrl+k" = "gaps inner all plus 5";

        # brightness keys
        "XF86MonBrightnessDown" = "exec light -U 20";
        "XF86MonBrightnessUp" = "exec light -A 20";

        # audio keys
        "XF86AudioRaiseVolume" = "exec pamixer -i 10";
        "XF86AudioLowerVolume" = "exec pamixer -d 10";
        "XF86AudioMute" = "exec pamixer -t";
        "Shift+XF86AudioMute" = "exec pamixer --default-source -t";

        # media keys
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
      };
      gaps = {
        smartGaps = true;
        inner = 5;
        smartBorders = "on";
      };
      bars = [{
        command = "waybar";
      }];
      startup = [
        { command = "${pkgs.autotiling}/bin/autotiling"; always = true; } # better tiling
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = true; }
      ];
      seat.seat0.xcursor_theme = config.gtk.cursorTheme.name;
    };
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    XDG_SESSION_DESKTOP = "sway";
  };

  services = {
    swayidle = {
      enable = true;
      timeouts = [
        { timeout = 300; command = "${swaylock} --grace 5"; }
        {
          timeout = 360;
          command = ''swaymsg "output * dpms off"''; # TODO: doesn't work
          resumeCommand = ''swaymsg "output * dpms on"'';
        }
      ];
      events = [{ event = "before-sleep"; command = swaylock; }];
    };
  };


  programs = {
    swaylock.settings = {
      daemonize = true;
      show-failed-attempts = true;
      screenshots = true;
      clock = true;
      indicator = true;
      effect-blur = "7x5";
      fade-in = "0.2";
    };
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          "layer" = "bottom";
          "position" = "top";
          "height" = 24;
          # "width": 1366;
          "modules-left" = [
            "sway/workspaces"
            "sway/mode"
          ];
          "modules-center" = [ "sway/window" ];
          "modules-right" = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" "clock" ];

          # modules:
          "sway/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = false;
            "format" = "{icon}";
            "format-icons" = {
              # "1:web" = "";
              # "2:code" = "";
              # "3:term" = "";
              # "4:work" = "";
              # "5:music" = "";
              # "6:docs" = "";
              # "urgent" = "";
              # "focused" = "";
              # "default" = "";
              # "1" = "";
              # "2" = "";
              # "3" = "";
              # "4" = "";
              # "5" = "";
              # "6" = "";
            };
          };
          "sway/mode" = {
            "format" = "<span style=\"italic\">{}</span>";
          };
          "sway/window" = {
            "max-length" = 50;
          };
          "tray" = {
            # "icon-size" = 21;
            "spacing" = 10;
          };
          "clock" = {
            "format-alt" = "{:%Y-%m-%d}";
          };
          "cpu" = {
            "format" = "{usage}% ";
          };
          "memory" = {
            "format" = "{}% ";
          };
          "battery" = {
            "bat" = "BAT1";
            "states" = {
              # "good": 95;
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            # "format-charging" = "{capacity}% ";
            # "format-plugged" = "{capacity}% ";
            "format-alt" = "{time} {icon}";
            # "format-good" = "", # An empty format will hide the module
            # "format-full" = "";
            "format-icons" = [ " " " " " " " " " " ];
          };
          "network" = {
            # "interface" = "wlp2s0", # (Optional) To force the use of this interface
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ifname}: {ipaddr}/{cidr} ";
            "format-disconnected" = "Disconnected ⚠";
          };
          "pulseaudio" = {
            "scroll-step" = 10;
            "format" = "{volume}% {icon}";
            "format-bluetooth" = "{volume}% {icon}";
            "format-muted" = "";
            "format-icons" = {
              "headphones" = "";
              "handsfree" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [ "" "" ];
            };
            "on-click" = "pavucontrol";
          };
        };
      };

      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: "Ubuntu Nerd Font";
            font-size: 13px;
            min-height: 0;
        }

        window#waybar {
            background: transparent;
            color: white;
        }

        #window {
            font-weight: bold;
            /*font-family: "Ubuntu";*/
        }
        /*
        #workspaces {
            padding: 0 5px;
        }
        */

        #workspaces button {
            padding: 0 5px;
            background: transparent;
            color: white;
            border-top: 2px solid transparent;
        }

        #workspaces button.focused {
            color: #c9545d;
            border-top: 2px solid #c9545d;
        }

        #mode {
            background: #64727D;
            border-bottom: 3px solid white;
        }

        #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode {
            padding: 0 3px;
            margin: 0 2px;
        }

        #clock {
            font-weight: bold;
        }

        #battery {
        }

        #battery icon {
            color: red;
        }

        #battery.charging {
        }

        @keyframes blinkw {
            to {
                background-color: #ffffff;
                color: black;
            }
        }

        @keyframes blinkc {
            to {
                background-color: #ff0000;
            }
        }

        #battery.warning:not(.charging) {
            color: white;
            animation-name: blinkw;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #battery.critical:not(.charging) {
            color: white;
            animation-name: blinkc;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #cpu {
        }

        #memory {
        }

        #network {
        }

        #network.disconnected {
            background: #f53c3c;
        }

        #pulseaudio {
        }

        #pulseaudio.muted {
        }

        #tray {
        }
      '';
    };
  };
}
