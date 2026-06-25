_: {
  flake.homeModules.ai = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      acceleration = "cuda";
    };
  };
}
