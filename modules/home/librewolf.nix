{
  # Plugins:
  # Vimium-FF
  # uBlock Origin:
  # fanboy's annoyance TODO makes browser more unique?
  # advanced user enabled
  # * * 3p-frame block
  # * * 3p-script block
  programs.librewolf = {
    enable = true;
    settings = {
      "browser.uidensity" = 1; # compact mode
      "browser.startup.page" = 3; # restore session
      "browser.warnOnQuitShortcut" = false;
      # "identity.fxaccounts.enabled" = true; # Firefox Sync
      # "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # userChrome.css customization

      # "webgl.disabled" = false; # use Canvas Blocker if enabled
      "privacy.resistFingerprinting" = true; # better than user agent switcher
      "privacy.resistFingerprinting.letterboxing" = true;
      "privacy.clearOnShutdown.history" = false;
      # "privacy.clearOnShutdown.downloads" = false; # TODO: check what this does

      # "security.OCSP.require" = false; # if it breaks again

      # "privacy.clearOnShutdown.cookies" = false;
      # "network.cookie.lifetimePolicy" = 0;
    };
  };
}
