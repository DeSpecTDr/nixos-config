{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO:
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-doom-emacs = {
    #   url = "github:nix-community/nix-doom-emacs";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nil = {
    #   url = "github:oxalica/nil";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nur = {
    #   url = "nur";
    # };

    # agenix = { # TODO: sops-nix instead?
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # webcord.url = "github:fufexan/webcord-flake";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    user = "user";

    overlays = [
      (final: prev:
        with inputs; {
          unstable = unstable.legacyPackages.${prev.system};
          # rnix-lsp = rnix-lsp.defaultPackage.${prev.system};
          # webcord = webcord.packages.${prev.system}.default;
          # nil = nil.packages.${prev.system}.default; # check it later
        })
    ];
  in {
    nixosConfigurations = import ./hosts {
      inherit (nixpkgs) lib;
      inherit nixpkgs overlays home-manager inputs user;
    };
  };
}
