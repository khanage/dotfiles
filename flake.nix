{
  description = "Dotfiles - delegates to system-specific flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin-flake.url = "path:./darwin";
    nixos-flake.url = "path:./nixos";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (top @ {
      config,
      withSystem,
      moduleWithSystem,
      ...
    }: {
      flake = {
        # Re-export darwin and nixos configurations
        darwinConfigurations = inputs.darwin-flake.outputs.darwinConfigurations;
        darwinModules = inputs.darwin-flake.outputs.darwinModules;
        nixosConfigurations = inputs.nixos-flake.outputs.nixosConfigurations;
      };
      systems = [
        "x86_64_linux"
        "aarch64-darwin"
      ];
      perSystem = {
        config,
        pkgs,
        ...
      }: {
      };
    });
}
