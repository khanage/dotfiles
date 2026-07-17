_: {
  flake.homeModules.three_d_printing = {pkgs, ...}: {
    home.packages = with pkgs; [
      # freecad-wayland
      # withNvidiaGLWorkaround routes through Mesa+Zink which exhausts BAR
      # (heap 3) memory during slicing, causing OOM crashes. Use native NVIDIA
      # OpenGL instead. If the 3D viewport appears blank, re-enable this.
      # See: https://github.com/NixOS/nixpkgs/issues/498311
      bambu-studio
    ];
  };
}
