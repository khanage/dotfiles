_: {
  flake.homeModules.three_d_printing = {pkgs, ...}: {
    home.packages = with pkgs; [
      # bambu-studio
      freecad-wayland
    ];
  };
}
