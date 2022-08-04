{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils.url = "flake-utils";

    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs-wayland = {
    #   url = "github:nix-community/nixpkgs-wayland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nur.url = "nur";

    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager, nix-doom-emacs, ... }: {
    nixosConfigurations = {
      # TODO: change hostname from nixos to something else
      "nixos" =
        let
          system = "x86_64-linux";
          overlay-unstable = final: prev: {
            # TODO: move to outputs.overlays
            unstable = nixpkgs-unstable.legacyPackages.${prev.system};
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ overlay-unstable ]; }
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.user = nixpkgs.lib.mkMerge [
                  nix-doom-emacs.hmModule
                  (import ./modules/home) # (inputs // { inherit inputs; };)
                ];
                extraSpecialArgs = { inherit inputs; };
              };
            }
            # agenix.nixosModule
          ];
        };
    };
  };
}
