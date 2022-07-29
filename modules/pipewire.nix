{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pamixer # move to sway.nix as ${pkgs.pamixer}?
    pavucontrol
    helvum
    # paprefs
    # easyeffects
    # noisetorch
  ];

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
