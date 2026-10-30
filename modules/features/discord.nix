{...}: {
  perSystem = {pkgs, ...}: {
    packages.myDiscord = pkgs.discord-ptb.override {
      source = builtins.fromJSON ''
        {
          "distro": {
            "hash": "sha256-jo2uIQrEirr2cyJcEV/pdNa1n+mIFRHZNVD+eK+gb3U=",
            "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/full.distro"
          },
          "kind": "distro",
          "modules": {
            "discord_cloudsync": {
              "hash": "sha256-ScoJJgsKRu1KjK1N6oixKp6Nc7/y1ksHOJ+GZK7CD/I=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_cloudsync/1/full.distro",
              "version": 1
            },
            "discord_desktop_core": {
              "hash": "sha256-DIYGtcsICZ8ziCZnCaDlvlm+lUgxGjEvai1+ejO4crQ=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_desktop_core/1/full.distro",
              "version": 1
            },
            "discord_dispatch": {
              "hash": "sha256-BSFHEsitZ1tqfp1tuOX+lEYTFhrbbiuHv0UXLO0wpYM=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_dispatch/1/full.distro",
              "version": 1
            },
            "discord_erlpack": {
              "hash": "sha256-fz9+eQG0ASEJHuMsilBCBitZK7OKLON5YWX0WSzRctM=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_erlpack/1/full.distro",
              "version": 1
            },
            "discord_game_utils": {
              "hash": "sha256-PW6DdrgGYXMg1oVizybTGH69GGMVj7lVuQIpmgfFQ/Q=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_game_utils/1/full.distro",
              "version": 1
            },
            "discord_krisp": {
              "hash": "sha256-VidcoCVtJod0uMG8kT6TyNKcy7GhVoyPgsdQTOLnDsQ=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_krisp/1/full.distro",
              "version": 1
            },
            "discord_modules": {
              "hash": "sha256-BVUzpC6VvlMFugVfeTSxcSmWwQ0EmWIZlx6wHvsdSus=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_modules/1/full.distro",
              "version": 1
            },
            "discord_ndi": {
              "hash": "sha256-YdHz1EhXAxDjFLDBTaO0Pe3mgpSbhty4yU94Kw8iBCs=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_ndi/1/full.distro",
              "version": 1
            },
            "discord_rpc": {
              "hash": "sha256-8qS3sk2wtU/NyIyWAEYOt6KCybjRu1mLD0QIdBuvCXU=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_rpc/1/full.distro",
              "version": 1
            },
            "discord_spellcheck": {
              "hash": "sha256-MN3TRsv6kGc1sMKDzDLFnMxB6kDyPFZeT24YnxZOcKQ=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_spellcheck/1/full.distro",
              "version": 1
            },
            "discord_sysimg": {
              "hash": "sha256-LQklwgLKCrmClcsVMkBbb+WJjdsTNP3UnoBr/nJ0iuA=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_sysimg/1/full.distro",
              "version": 1
            },
            "discord_utils": {
              "hash": "sha256-l3WTkunoSPf54uz569pbcUO9dcgAthCH0RJXj8FeqcE=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_utils/1/full.distro",
              "version": 1
            },
            "discord_voice": {
              "hash": "sha256-+dhI05Kztg7g4NVhNUG8C8G/AkXHlywaNkwQeYR3a04=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_voice/1/full.distro",
              "version": 1
            },
            "discord_zstd": {
              "hash": "sha256-nC0yBkzvAg394vllbouNbUiXeuHFLbzaZ2yulYHoPkg=",
              "url": "https://ptb.dl2.discordapp.net/distro/app/ptb/linux/x64/1.0.218/discord_zstd/1/full.distro",
              "version": 1
            }
          },
          "version": "1.0.218"
        }
      '';
    };
  };
}
