_: {
  flake.homeModules.ssh = _: {
    programs.ssh = {
      enable = true;

      matchBlocks = {
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
