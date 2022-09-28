{
  # Plugins:
  # Vimium-FF
  # Libredirect
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
      "browser.warnOnQuitShortcut" = false; # exit with Ctrl+Q without warning
      # "identity.fxaccounts.enabled" = true; # Firefox Sync
      # "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # userChrome.css customization

      # "webgl.disabled" = false; # use Canvas Blocker if enabled
      "privacy.resistFingerprinting" = true;
      "privacy.resistFingerprinting.letterboxing" = true;
      "privacy.clearOnShutdown.history" = false;
      # "privacy.clearOnShutdown.downloads" = false; # TODO: check what this does
      # "browser.display.use_document_fonts" = 0; # does RFP do this?

      # "security.OCSP.require" = false; # if it breaks again
    };
  };
}
