{
  description = "A flake template for nix-darwin and Determinate Nix";

  # Flake inputs
  inputs = {
    # Stable Nixpkgs (use 0.1 for unstable)
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    system = "aarch64-darwin";
  in {
    # nix-darwin configuration output
    darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem {
      inherit system;
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
            brews = ["python@3.13"];
            casks = ["hammerspoon" "docker-desktop"];
          };
        })
      ];
    };

    # nix-darwin module outputs
    darwinModules = {
      # Some base configuration
      base = {
        config,
        pkgs,
        lib,
        ...
      }: {
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
      nixConfig = {
        config,
        pkgs,
        lib,
        ...
      }: {
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
    devShells.${system}.default = let
      pkgs = import inputs.nixpkgs {inherit system;};
    in
      pkgs.mkShellNoCC {
        packages = with pkgs; [
          # Shell script for applying the nix-darwin configuration.
          # Run this to apply the configuration in this flake to your macOS system.
          (writeShellApplication {
            name = "apply-nix-darwin-configuration";
            runtimeInputs = [
              # Make the darwin-rebuild package available in the script
              inputs.nix-darwin.packages.${system}.darwin-rebuild
            ];
            text = ''
              echo "> Applying nix-darwin configuration..."

              echo "> Running darwin-rebuild switch as root..."
              sudo darwin-rebuild switch --flake .
              echo "> darwin-rebuild switch was successful ✅"

              echo "> macOS config was successfully applied 🚀"
            '';
          })

          self.formatter.${system}
        ];
      };

    # Nix formatter

    # This applies the formatter that follows RFC 166, which defines a standard format:
    # https://github.com/NixOS/rfcs/pull/166

    # To format all Nix files:
    # git ls-files -z '*.nix' | xargs -0 -r nix fmt
    # To check formatting:
    # git ls-files -z '*.nix' | xargs -0 -r nix develop --command nixfmt --check
    formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
  };
}
