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
          (builtins.readFile "${fluentbird-src}/userChrome.css")
          + ''
            /* Local fixes for Fluentbird in this Thunderbird setup. */
            #messengerBody {
              opacity: 1 !important;
            }

            #spacesToolbar {
              background-color: var(--toolbar-bgcolor, #f3f3f3) !important;
            }

            .recipient-avatar {
              width: 32px !important;
              height: 32px !important;
              font-size: 1rem !important;
            }
          '';
      };
      package = pkgs.thunderbird.override {
        extraPolicies = {
          ExtensionSettings = {
            "autoprofilepicture@astucesweb.fr" = {
              installation_mode = "force_installed";
              install_url = "https://addons.thunderbird.net/thunderbird/downloads/latest/auto-profile-picture/latest.xpi";
            };
          };
        };
      };
    };
    home.file.".thunderbird/khan/chrome".source = fluentbird-src;
  };
}
