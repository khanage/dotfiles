{
  description = "Dotfiles - delegates to system-specific flakes";

  inputs = {
    # System-specific flakes
    darwin-flake.url = "path:./darwin";
    nixos-flake.url = "path:./nixos";
  };

  outputs = { self, darwin-flake, nixos-flake, ... }:
  {
    # Re-export darwin and nixos configurations
    darwinConfigurations = darwin-flake.outputs.darwinConfigurations;
    darwinModules = darwin-flake.outputs.darwinModules;
    nixosConfigurations = nixos-flake.outputs.nixosConfigurations;
  };
}
