{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.marvin = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      flake-parts-lib = inputs.flake-parts.lib;
    };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.marvinConfiguration
    ];
  };
}
