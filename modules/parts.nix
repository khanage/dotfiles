{inputs, ...}: {
  config = {
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    _module.args.flake-parts-lib = inputs.flake-parts.lib;
    perSystem = {system, ...}: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages =
            [
              "dotnet-sdk-6.0.428"
            ]
            ++ (
              if system == "x86_64-linux"
              then [
                "openssl-1.1.1w"
              ]
              else []
            );
        };
      };
    };
  };
}
