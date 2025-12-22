{config, ...}: {
  # Homebrew - Mac-specific packages that aren't in Nix
  # Requires Homebrew to be installed
  system.activationScripts.applications = {
    text = ''
      if ! xcode-select --version 2>/dev/null; then
        $DRY_RUN_CMD sudo xcode-select --install
      fi
      if ! /opt/homebrew/bin/brew --version 2>/dev/null; then
        $DRY_RUN_CMD sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    '';
  };

  # Add homebrew paths to CLI path
  home-manager.users.khanthompson.home.sessionPath = ["/opt/homebrew/bin/"];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false; # Don't update during rebuild
      cleanup = "zap"; # Uninstall all programs not declared
      upgrade = true;
    };
    global = {
      brewfile = true; # Run brew bundle from anywhere
      lockfiles = false; # Don't save lockfile (since running from anywhere)
    };
    brews = [
      "trash" # Delete files and folders to trash instead of rm
    ];
    casks = [
      "notunes" # Don't launch Apple Music with the play button
      "hammerspoon"
    ];
  };
}
