{
  self,
  inputs,
  ...
}: let
  hostname = "PB-C2WK69P06Y";
  system = "aarch64-darwin";
in {
  flake.darwinConfigurations.${hostname} = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit inputs;
      flake-parts-lib = inputs.flake-parts.lib;
    };
    modules = [
      inputs.home-manager.darwinModules.home-manager
      inputs.determinate.darwinModules.default
      self.darwinModules.workConfiguration
    ];
  };
}
