{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # move to home?
    pamixer
    pavucontrol
    # helvum
    # paprefs
    easyeffects
  ];

  programs.noisetorch.enable = true; # noise suppression

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    # alsa = {
    #   enable = true;
    #   support32Bit = true;
    # };
  };
}
