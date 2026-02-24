{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nvf,
    noctalia,
    ...
  } @ inputs: let
    home_system = "x86_64-linux";
  in {
    nixosConfigurations = {
      homepc = nixpkgs.lib.nixosSystem {
        system = home_system;
        modules = [
          {nixpkgs.overlays = [inputs.nix-vscode-extensions.overlays.default];}
          ../nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                inputs.nvf.homeManagerModules.default
                inputs.noctalia.homeModules.default
              ];
              users.khan = ../home-manager/home.nix;
            };
          }
        ];
      };
    };

    formatter.${home_system} = inputs.nixpkgs.legacyPackages.${home_system}.nixfmt-rfc-style;
  };
}
