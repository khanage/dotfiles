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
      # BUG: https://github.com/nixos/nixpkgs/issues/471331
      overlays = [
        # BUG: apm-cli missing websockets dep in nixpkgs
        (final: prev: {
          apm-cli = prev.apm-cli.overridePythonAttrs (old: {
            propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [final.python3Packages.websockets];
          });
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
