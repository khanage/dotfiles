_: {
  flake.homeModules.gimp = {pkgs, ...}: {
    home.packages = [pkgs.gimp];
  };
}
