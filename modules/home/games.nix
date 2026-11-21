_: {
  flake.homeModules.gaming = {myDiscord, ...}: {
    home.packages = [
      myDiscord
      # xivlauncher
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
