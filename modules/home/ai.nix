{self, ...}: {
  flake.homeModules.ai = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };
}
