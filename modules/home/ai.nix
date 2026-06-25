_: {
  flake.homeModules.ai = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cpu;
    };
  };
}
