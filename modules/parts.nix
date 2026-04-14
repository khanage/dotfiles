{
  inputs,
  ...
}: {
  config = {
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    _module.args.flake-parts-lib = inputs.flake-parts.lib;
    perSystem = {system, ...}: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
  };
}
