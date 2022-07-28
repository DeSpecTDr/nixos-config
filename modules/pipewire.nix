{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
    paprefs # TODO comment out
    helvum
    # easyeffects
    # noisetorch
  ];

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    # alsa.enable = true;
    # alsa.support32Bit = true;
    pulse.enable = true;
  };
}
