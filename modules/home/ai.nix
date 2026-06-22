{self, ...}: {
  flake.homeModules.ai = {pkgs, ...}: {
    services.ollama = {
      enable = false;
    };
  };
}
