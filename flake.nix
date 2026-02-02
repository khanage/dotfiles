{
  description = "A flake template for nix-darwin and Determinate Nix";

  # Flake inputs
  inputs = {
    # Stable Nixpkgs (use 0.1 for unstable)
    nixpkgs = {
      # https://github.com/nixos/nixpkgs/issues/483584
      url = "github:NixOS/nixpkgs/70801e06d9730c";
      # url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    # Stable nix-darwin (use 0.1 for unstable)
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Determinate 3.* module
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  # Flake outputs
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nvf,
    nix-homebrew,
    ...
  } @ inputs: let
    # The values for `username` and `system` supplied here are used to construct the hostname
    # for your system, of the form `${username}-${system}`. Set these values to what you'd like
    # the output of `scutil --get LocalHostName` to be.
    # Your system username
    username = "khanthompson";

    hostname = "PB-C2WK69P06Y";

    # Your system type (Apple Silicon)
    apple_system = "aarch64-darwin";
    home_system = "x86_64-linux";
  in {
    nixosConfigurations = {
      homepc = nixpkgs.lib.nixosSystem {
        specialArgs = {
          system = home_system;
        };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [nvf.homeManagerModules.default];
              users.khan = ./home-manager/home.nix;
            };
          }
        ];
      };
    };

    # nix-darwin configuration output
    darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem {
      system = apple_system;
      modules = [
        inputs.determinate.darwinModules.default
        self.darwinModules.base
        self.darwinModules.nixConfig

        home-manager.darwinModules.home-manager
        {
          home-manager = {
            backupFileExtension = ".bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [nvf.homeManagerModules.default];
            users.${username} = ./home-manager/work.nix;
          };
        }

        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "khanthompson";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            mutableTaps = false;
          };
        }

        ({config, ...}: {
          homebrew = {
            enable = true;
            taps = builtins.attrNames config.nix-homebrew.taps;
            brews = ["python@3.13" "pngpaste"];
            casks = ["hammerspoon" "docker-desktop" "miro" "kitty"];
          };
        })
      ];
    };

    # nix-darwin module outputs
    darwinModules = {
      # Some base configuration
      base = _: {
        # Required for nix-darwin to work
        system.stateVersion = 1;

        users.users.${username} = {
          name = username;
          home = /Users/khanthompson;
          # See the reference docs for more on user config:
          # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users
        };

        # Other configuration parameters
        # See here: https://nix-darwin.github.io/nix-darwin/manual
        system.primaryUser = "khanthompson";
        system.defaults = {
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
        };
      };

      # Nix configuration
      nixConfig = _: {
        # Let Determinate Nix handle your Nix configuration
        nix.enable = false;

        # Custom Determinate Nix settings written to /etc/nix/nix.custom.conf
        determinate-nix.customSettings = {
          # Enables parallel evaluation (remove this setting or set the value to 1 to disable)
          eval-cores = 0;
          extra-experimental-features = [
            "build-time-fetch-tree" # Enables build-time flake inputs
            "parallel-eval" # Enables parallel evaluation
          ];
          # Other settings
        };
      };

      # Add other module outputs here
    };

    # Development environment
    devShells.${apple_system}.default = let
      pkgs = import inputs.nixpkgs {system = apple_system;};
    in
      pkgs.mkShellNoCC {
        packages = with pkgs; [
          # Shell script for applying the nix-darwin configuration.
          # Run this to apply the configuration in this flake to your macOS system.
          (writeShellApplication {
            name = "apply-nix-darwin-configuration";
            runtimeInputs = [
              # Make the darwin-rebuild package available in the script
              inputs.nix-darwin.packages.${apple_system}.darwin-rebuild
            ];
            text = ''
              echo "> Applying nix-darwin configuration..."

              echo "> Running darwin-rebuild switch as root..."
              sudo darwin-rebuild switch --flake .
              echo "> darwin-rebuild switch was successful ✅"

              echo "> macOS config was successfully applied 🚀"
            '';
          })

          self.formatter.${apple_system}
        ];
      };

    # Nix formatter

    # This applies the formatter that follows RFC 166, which defines a standard format:
    # https://github.com/NixOS/rfcs/pull/166

    # To format all Nix files:
    # git ls-files -z '*.nix' | xargs -0 -r nix fmt
    # To check formatting:
    # git ls-files -z '*.nix' | xargs -0 -r nix develop --command nixfmt --check
    formatter.${apple_system} = inputs.nixpkgs.legacyPackages.${apple_system}.nixfmt-rfc-style;
  };
}
