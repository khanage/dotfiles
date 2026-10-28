_: {
  flake.homeModules.email = {pkgs, ...}: let
    fluentbird-src = pkgs.fetchFromGitHub {
      owner = "Deathbyteacup";
      repo = "fluentbird";
      rev = "1.1.4";
      sha256 = "sha256-9OUBfPiYdIzJ5NaxnZ8NXJxi9eZqGoPac3Hg8HOop+Q=";
    };
  in {
    programs.thunderbird = {
      enable = true;
      profiles.khan = {
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome =
          builtins.readFile "${fluentbird-src}/userChrome.css"
          + ''
            /* NixOS/Linux Sidebar Transparency Fallback Fix */
            #folderPane, 
            #sidebar-box, 
            .sidebar-panel, 
            #background-box {
              background-color: var(--sidebar-background, -moz-Dialog) !important;
              opacity: 1 !important;
            }

            /* Forces a dark/light system adaptive background if variables mismatch */
            @media (prefers-color-scheme: dark) {
              #folderPane {
                background-color: #1e1e1e !important; /* Standard Windows 11 Dark backdrop */
              }
            }
            @media (prefers-color-scheme: light) {
              #folderPane {
                background-color: #f3f3f3 !important; /* Standard Windows 11 Light backdrop */
              }
            }
          '';
      };
      # package = pkgs.thunderbird.override {
      #   extraPolicies = {
      #     ExtensionSettings = {
      #       "autoprofilepicture@astucesweb.fr" = {
      #         installation_mode = "force_installed";
      #         install_url = "https://addons.thunderbird.net/thunderbird/downloads/latest/auto-profile-picture/latest.xpi";
      #       };
      #     };
      #   };
      # };
    };
    home.file.".thunderbird/khan/chrome".source = fluentbird-src;
  };
}
