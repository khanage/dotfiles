_: {
  flake.homeModules.ai = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      acceleration = "cuda";
      package = pkgs.ollama-cuda;
      environmentVariables = {OLLAMA_CONTEXT_LENGTH = "64000";};
    };
  };
}
