{inputs, ...}: {
  flake.darwinModules.homebrew = _: rec {
    imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];
    nix-homebrew = {
      # Install Homebrew under the default prefix
      enable = true;

      # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
      enableRosetta = true;

      # User owning the Homebrew prefix
      user = "khanthompson";

      # Optional: Declarative tap management
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };

      # Optional: Enable fully-declarative tap management
      mutableTaps = false;
    };

    homebrew = {
      enable = true;
      taps = builtins.attrNames nix-homebrew.taps;

      brews = ["python@3.13" "pngpaste"];
      casks = ["hammerspoon" "docker-desktop" "miro" "kitty"];
    };
  };
}
