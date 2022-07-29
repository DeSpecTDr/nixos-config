{ pkgs, ... }:
# let
#   swayRun = pkgs.writeShellScript "sway-run" ''
#     export XDG_SESSION_TYPE=wayland
#     export XDG_SESSION_DESKTOP=sway
#     export XDG_CURRENT_DESKTOP=sway
#     systemd-run --user --scope --collect --quiet --unit=sway systemd-cat --identifier=sway ${pkgs.sway}/bin/sway $@
#   '';
# in
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "sway";
        user = "user";
      };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
