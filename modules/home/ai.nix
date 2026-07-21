_: {
  flake.homeModules.ai = {pkgs, ...}: let
    optionalAttrs = pkgs.lib.optionalAttrs;
  in {
    services.ollama =
      {
        enable = true;
        environmentVariables = {OLLAMA_CONTEXT_LENGTH = "64000";};
      }
      // optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        acceleration = "cuda";
        package = pkgs.ollama-cuda;
      }
      // optionalAttrs pkgs.stdenv.hostPlatform.isDarwin
      {
        package = pkgs.ollama.overrideAttrs (oldAttrs: {
          # Unable to load mlx on apple hardware, and setting DYLOAD path has no effect.
          postPatch =
            (oldAttrs.postPatch or "")
            + ''
              # Find where Ollama defines its rigid Apple runner search array
              # and forcefully append the Nix store MLX library path into the lookups
              substituteInPlace discover/gpu_darwin.go \
                --replace '"/usr/local/lib"', '"${pkgs.python3Packages.mlx}/lib", "/usr/local/lib"'
            '';
        });
      };
  };
}
