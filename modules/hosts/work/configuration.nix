{self, ...}: let
  username = "khanthompson";
in {
  flake.darwinModules.workConfiguration = _: {
    imports = [
      self.darwinModules.workHomeManager
      self.darwinModules.homebrew
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
        (_: prev: {
          xow_dongle-firmware = prev.xow_dongle-firmware.overrideAttrs (_: {
            installPhase = ''
              # Create the firmware directory
              mkdir -p $out/lib/firmware

              # Install the standard bin file (just in case)
              install -Dm644 xow_dongle.bin $out/lib/firmware/xow_dongle.bin

              ln -s $out/lib/firmware/xow_dongle.bin $out/lib/firmware/xone_dongle_02fe.bin

              # Handle the other model mentioned in the bug report (optional, but safe to keep)
              if [ -f xow_dongle_045e_02e6.bin ]; then
                install -Dm644 xow_dongle_045e_02e6.bin $out/lib/firmware/xone_dongle_02e6.bin
              fi
            '';
          });
        })
        (
          final: prev: let
            name = "rust-analyzer-unwrapped";
            version = "2026-02-16";
            src = final.fetchFromGitHub {
              owner = "rust-lang";
              repo = "rust-analyzer";
              rev = "00a9173e57f5c4ba45e380ce065b31afb17436ad";
              hash = "sha256-1TZROjtryMzOJHgHhAUQUoAMnnWal231G7gM1pfNlK4=";
            };
          in {
            ${name} = prev.${name}.overrideAttrs (_: rec {
              inherit version src;

              cargoDeps = prev.rustPlatform.fetchCargoVendor {
                inherit src;
                name = "rust-analyzer-${version}";
                hash = "sha256-1Brx4mvT8683zhrFkfL15/ynfgewyd7WcFFdKvDL3+Q=";
              };
            });
          }
        )
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
