_: {
  flake.homeModules.three_d_printing = {pkgs, ...}: {
    home.packages = with pkgs; [
      # freecad-wayland
      (bambu-studio.override
        {
          withNvidiaGLWorkaround = true;
        })
    ];
  };
}
