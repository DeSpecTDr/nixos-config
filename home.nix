{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ckan
    thunderbird-wayland
    vlc
    mpv
  ];

  # programs.waybar.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # For Pycharm
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    config = {
      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:alt_shift_toggle";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
      output = {
        "*" = { bg = "~/nixos/wallpaper.jpg fill"; };
      };
      terminal = "alacritty";
      menu = "bemenu-run";
      modifier = "Mod4"; # Super
      keybindings =
        let
          cfg = config.wayland.windowManager.sway.config;
        in
        lib.mkOptionDefault {
          "${cfg.modifier}+q" = "kill";
          "${cfg.modifier}+c" = ''exec grim -g "$(slurp)" - | wl-copy'';
          "Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2"; # TODO doesn't work

          # Brightness
          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";

          # Volume TODO switch to pavucontrol? pamixer? pactl?
          "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
          "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
          "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
        };
      # Status bar(s)
      # bars = [{
      #   # fonts.size = 15.0;
      #   command = "waybar";
      #   position = "bottom";
      # }];
    };
    extraConfig = ''
      exec dbus-sway-environment
      exec configure-gtk
    '';
  };

  services.swayidle = {
    enable = true;
    timeouts = [{
      timeout = 300;
      command = ''swaymsg "output * dpms off"'';
      resumeCommand = ''swaymsg "output * dpms on"'';
    }];
  };


  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        ms-toolsai.jupyter
        usernamehw.errorlens
        asvetliakov.vscode-neovim
        vadimcn.vscode-lldb
        serayuzgur.crates
        tamasfe.even-better-toml
        arrterian.nix-env-selector
        jnoortheen.nix-ide
        ms-python.python
      ];
    };

    fish = {
      enable = true;
      shellAliases = {
        nix-upd = "nix flake update ~/nixos";
        nix-reb = "sudo nixos-rebuild switch --flake ~/nixos";
        e = "nvim ";
        se = "EDITOR=nvim sudo -e ";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = false; # enabled in oh-my-zsh
      # initExtra = ''
      #   test -f ~/.dir_colors && eval $(dircolors ~/.dir_colors)
      # '';
      # shellAliases = {
      #   ne = "nix-env";
      #   ni = "nix-env -iA";
      #   no = "nixops";
      #   ns = "nix-shell --pure";
      #   please = "sudo";
      # };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "systemd" "rsync" "kubectl" ];
        theme = "terminalparty";
      };
    };

    nix-index.enable = true; # TODO: is it really needed?

    git = {
      enable = true;
      userName = "DeSpecTDr";
      userEmail = "73001251+DeSpecTDr@users.noreply.github.com";
    };

    neovim = {
      enable = true;
      # TODO set editor for sudo or use emacs+doas
    };
  };

  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
  };

  programs.home-manager.enable = true;
}
