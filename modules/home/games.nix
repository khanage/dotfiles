_: {
  flake.homeModules.gaming = {pkgs, ...}: {
    home.packages = with pkgs; [
      wowup-cf
      xivlauncher
    ];
  };
}
