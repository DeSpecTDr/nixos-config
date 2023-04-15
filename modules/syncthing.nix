{user, ...}: {
  services.syncthing = {
    enable = true;
    user = user;
    dataDir = "/home/${user}";
    devices = {
      laptop = {id = "PW5ICS4-BC7BS7M-JBY2X53-IQWNHQD-7FGK5JK-CSBNTNL-6FEQZPS-TNTINQ5";};
      desktop = {id = "";};
      phone = {id = "BQPYFG2-UJL6UBD-67OCSSH-BMUYYRC-G2D53H4-PPW2PYY-PQPFSYZ-2NQQFA6";};
    };
    folders."/home/${user}/Sync" = {
      id = "Sync";
      label = "Sync";
      devices = ["laptop" "desktop" "phone"];
    };
  };
}
