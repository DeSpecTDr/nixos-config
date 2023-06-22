{pkgs, ...}: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };
  services = {
    gvfs.enable = true; # to mount android phone
    udisks2.enable = true; # NOTE: enabled by gvfs by default
    tumbler.enable = true;
    # devmon.enable = true; # automount
  };
  # xfce.exo for exo-open?
}
