{
  lib,
  nixpkgs,
  overlays,
  home-manager,
  inputs,
  user,
}: {
  laptop = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs user;};
    modules = [
      {nixpkgs.overlays = overlays;}
      ./laptop
      ./common.nix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user;};
          users.${user} = lib.mkMerge [
            (import ./home.nix)
            # inputs.nix-doom-emacs.hmModule
            (import ./laptop/home.nix)
          ];
        };
      }
      # inputs.nur.nixosModules.nur
      # inputs.agenix.nixosModule
    ];
  };

  desktop = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs user;};
    modules = [
      {nixpkgs.overlays = overlays;}
      ./desktop
      ./common.nix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user;};
          users.${user} = lib.mkMerge [
            (import ./home.nix)
            # inputs.nix-doom-emacs.hmModule
            (import ./desktop/home.nix)
          ];
        };
      }
    ];
  };
}
