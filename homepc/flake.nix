{
  description = "System flake";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/cad22e7d996aea55ecab064e84834289143e44a0";
    # Upstream broke - https://github.com/NotAShelf/nvf/issues/1312
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nvf,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      homepc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit system;};
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [nvf.homeManagerModules.default];
              users.khan = ./home-manager/home.nix;
            };
          }
        ];
      };
    };
  };
}
