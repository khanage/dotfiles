{inputs, ...}: {
  flake.nixosModules.flatpak = _: {
    imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
    services.flatpak = {
      update.onActivation = true;
      uninstallUnmanaged = true;

      packages = [
        "net.retrodeck.retrodeck"
        "com.bambulab.BambuStudio"
        "org.freecad.FreeCAD"
        "org.signal.Signal"
        "us.zoom.Zoom"
      ];
    };
  };
}
