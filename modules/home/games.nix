_: {
  flake.homeModules.gaming = {pkgs, ...}: {
    home.packages = with pkgs; [
      discord-ptb
      wowup-cf
      xivlauncher
    ];
  };
}
