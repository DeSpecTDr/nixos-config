{
  services.emacs.enable = true;

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ../../doom.d;
    # doomPackageDir = ; # for shorter rebuilds
  };
}
