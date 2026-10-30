_: {
  flake.homeModules.gaming = {
    pkgs,
    myDiscord,
    ...
  }: let
    battlenet = pkgs.makeDesktopItem {
      name = "Battle.net";
      desktopName = "battlenet";
      comment = "Run battlenet";
      exec = "steam steam://rungameid/18016972595085180928";
      icon = ../../resources/battlenet_logo.png;
      terminal = false;
      type = "Application";
    };
  in {
    home.packages = with pkgs; [
      wowup-cf
      myDiscord
      # xivlauncher
      battlenet
      # battlenetDesktop
    ];
  };
}
