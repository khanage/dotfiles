_: {
  flake.homeModules.gaming = {
    pkgs,
    myDiscord,
    ...
  }: let
    battlenetDesktop = pkgs.makeDesktopItem {
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
      # battlenet
      battlenetDesktop
    ];

    programs.battlenet-umu = let
      wow = "Program Files (x86)/World of Warcraft";
    in {
      enable = true;
      prefix = "/games/umu";
      games = [
        {name = "Battle.net";}
        {
          name = "WoW Forever";
          path = "${wow}/_forever_/Wow.exe";
        }
      ];
      addons = {
        enable = true;
        versions = [
          {
            name = "forever";
            addonDir = "${wow}/_forever_/Interface/Addons";
            flavour = "forever_classic";
            addons = [
              "curse:tradeskill-master"
              "curse:gargul"
              "curse:atlas-loot-forever"
              "curse:auctionator"
            ];
          }
        ];
      };
    };
  };
}
