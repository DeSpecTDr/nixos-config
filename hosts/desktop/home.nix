{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    prismlauncher # minecraft
  ];

  xsession.enable = true;
  xsession.windowManager.i3 = let mod = "Mod4"; in
    {
      enable = true;
      config = {
        terminal = "kitty";
        # menu = "";
        modifier = mod;
        keybindings = lib.mkOptionDefault {
          "${mod}+q" = "kill";
          "${mod}+c" = "exec flameshot gui";
          # "Ctrl+Alt+l" = "exec ${swaylock}";

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
        # bars = [{
        #   command = "waybar";
        # }];
        startup = [
          { command = "autotiling"; always = true; } # better tiling
        ];
      };
    };
}
