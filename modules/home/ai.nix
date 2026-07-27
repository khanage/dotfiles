_: {
  flake.homeModules.ai = {pkgs, ...}: let
    optionalAttrs = pkgs.lib.optionalAttrs;
  in {
    services.ollama =
      {
        enable = false;
        environmentVariables = {OLLAMA_CONTEXT_LENGTH = "64000";};
      }
      // optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        acceleration = "cuda";
        package = pkgs.ollama-cuda;
      };
  };
}
