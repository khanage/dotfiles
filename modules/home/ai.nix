_: {
  flake.homeModules.ai = {pkgs, ...}: let
    optionalAttrs = pkgs.lib.optionalAttrs;
  in {
    services.ollama =
      {
        enable = true;
        environmentVariables =
          {OLLAMA_CONTEXT_LENGTH = "64000";}
          // optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
            DYLD_LIBRARY_PATH = "${pkgs.python3Packages.mlx}/lib";
          };
      }
      // optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        acceleration = "cuda";
        package = pkgs.ollama-cuda;
      };
  };
}
