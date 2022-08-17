{
  # uBlock Origin:
  # fanboy's annoyance TODO makes browser more unique?
  # advanced user enabled
  # * * 3p-frame block
  # * * 3p-script block
  programs.librewolf = {
    enable = true;
    settings = {
      "browser.uidensity" = 1; # compact mode
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = true; # user agent switcher makes it even more unique
      "privacy.clearOnShutdown.history" = false;
      # "privacy.clearOnShutdown.cookies" = false;
      # "network.cookie.lifetimePolicy" = 0;
    };
  };
}
