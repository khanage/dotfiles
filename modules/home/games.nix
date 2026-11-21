_: {
  flake.homeModules.gaming = {
    pkgs,
    myDiscord,
    ...
  }: {
    home.sessionVariables = {
      DXVK_ASYNC = "1";
      STEAM_COMPAT_MOUNTS = "/games";
    };

    home.packages = with pkgs; [
      myDiscord
      wowup-cf
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
          launchArgs = "-d3d11";
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
              # "curse:atlasloot-forever"
              "curse:auctionator"
            ];
          }
        ];
      };
    };
  };
}
