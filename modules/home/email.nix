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
        userChrome = builtins.readFile "${fluentbird-src}/userChrome.css";
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
  };
}
