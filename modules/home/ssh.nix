_: {
  flake.homeModules.ssh = _: {
    programs.ssh = {
      enable = true;

      matchBlocks = {
        # Personal GitHub account (khanage). Force ONLY this identity so ssh
        # doesn't offer the default/work keys first.
        "github.com-personal" = {
          hostname = "github.com";
          user = "git";
          identityFile = "/run/secrets/github_personal_ssh_key";
          identitiesOnly = true;
        };
      };
    };
  };
}
