_: {
  flake.homeModules.ai = {pkgs, ...}: {
    services.ollama =
      {
        enable = true;
        environmentVariables = {OLLAMA_CONTEXT_LENGTH = "64000";};
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        acceleration = "cuda";
        package = pkgs.ollama-cuda;
      };
  };
}
