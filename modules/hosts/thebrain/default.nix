{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.thebrain = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      flake-parts-lib = inputs.flake-parts.lib;
    };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.thebrainConfiguration
    ];
  };
}
