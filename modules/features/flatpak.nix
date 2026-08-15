{inputs, ...}: {
  flake.nixosModules.flatpak = _: {
    imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
    services.flatpak = {
      update.auto.enable = true;
      uninstallUnmanaged = false;

      packages = [
        "net.retrodeck.retrodeck"
      ];
    };
  };
}
