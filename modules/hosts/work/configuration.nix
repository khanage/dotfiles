{self, ...}: let
  username = "khanthompson";
in {
  flake.darwinModules.workConfiguration = _: {
    imports = [
      self.darwinModules.workHomeManager
      self.darwinModules.homebrew
      self.darwinModules.sops
      self.darwinModules.sqlServer
    ];

    # Let Determinate Nix handle your Nix configuration
    nix.enable = false;

    nixpkgs = {
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "dotnet-sdk-6.0.428"
        ];
      };
      overlays = [
        (_: prev: {
          # azure-cli depends on Fabric, which requires Invoke < 3. Keep its
          # whole Python dependency set on the last known working nixpkgs pin;
          # newer nixpkgs marks Fabric broken against Invoke 3.
          # https://github.com/NixOS/nixpkgs/issues/575989
          inherit
            ((import (fetchTarball {
                url = "https://api.flakehub.com/f/pinned/NixOS/nixpkgs/0.2605.1012930%2Brev-c5c4a43b0e8056328ec4529f735cabdb8f1942bb/01a053c0-7061-7382-b001-102e9148a5b5/source.tar.gz";
                sha256 = "sha256-u6z9VTZA4Kf3RkHQo9sQI7NI4Ei/uiU9vrMqOiwWP1Y=";
              }) {
                system = prev.stdenv.hostPlatform.system;
                config.allowUnfree = true;
              }))
            azure-cli
            ;
        })
      ];
    };

    # Custom Determinate Nix settings written to /etc/nix/nix.custom.conf
    determinateNix.customSettings = {
      # Enables parallel evaluation (remove this setting or set the value to 1 to disable)
      eval-cores = 0;
      extra-experimental-features = [
        "build-time-fetch-tree" # Enables build-time flake inputs
        "parallel-eval" # Enables parallel evaluation
      ];
      # Other settings
    };

    system = {
      stateVersion = 1;

      # Other configuration parameters
      # See here: https://nix-darwin.github.io/nix-darwin/manual
      primaryUser = username;

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };

      defaults = {
        # minimal dock
        dock = {
          autohide = true;
          orientation = "left";
          show-process-indicators = false;
          show-recents = false;
          static-only = true;
        };
        # a finder that tells me what I want to know and lets me work
        finder = {
          AppleShowAllExtensions = true;
          ShowPathbar = true;
          FXEnableExtensionChangeWarning = false;
        };
        controlcenter.Bluetooth = true; # Show bluetooth in menu
        controlcenter.Sound = true;
        screencapture.target = "clipboard";
        spaces.spans-displays = false;
        WindowManager.EnableTiledWindowMargins = true;

        # This let's me move windows around
        CustomUserPreferences.NSGlobalDomain.NSUserKeyEquivalents = {
          "Right" = "@$l";
          "Left" = "@$h";
          "Top" = "@$k";
          "Bottom" = "@$j";
          "Top Left" = "@^h";
          "Bottom Left" = "@~h";
          "Top Right" = "@^l";
          "Bottom Right" = "@~l";
        };
      };
    };

    users.users.${username} = {
      name = username;
      home = /Users/${username};
      # See the reference docs for more on user config:
      # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users
    };
  };
}
