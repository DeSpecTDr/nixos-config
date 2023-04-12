{ pkgs, lib, ... }: {
  # Enable CUPS to print documents.
  # http://localhost:631
  # socket://192.168.0.36
  services.printing = {
    enable = true;
    drivers = [
      pkgs.cnijfilter2 # for Canon TS8040 (do not buy this model, it's terrible)
    ];
  };
}
