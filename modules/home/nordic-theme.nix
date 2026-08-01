_: {
  flake.homeModules.nordic-theme = {pkgs, ...}: let
    nordic = pkgs.stdenv.mkDerivation {
      pname = "nordic";
      version = "2.2.0-unstable-2026-07-23";
      src = pkgs.fetchFromGitHub {
        owner = "EliverLara";
        repo = "Nordic";
        rev = "be5bda37ba01139650e34238336e58e065d2f406";
        hash = "sha256-dQ9xc1kXqc4phCObAwWwHH//vm6NK6z61ieYV3NWWQE=";
      };
      dontFixup = true;
      installPhase = ''
        mkdir -p $out/share/themes/Nordic
        cp -r . $out/share/themes/Nordic
        # Remove KDE assets which contain broken symlinks
        rm -rf $out/share/themes/Nordic/kde
      '';
    };
  in {
    gtk = {
      enable = true;
      gtk4.theme = {
        name = "Nordic";
        package = nordic;
      };
      iconTheme = {
        name = "Zafiro-Icons-Dark";
        package = pkgs.zafiro-icons;
      };
    };
  };
}
