{inputs, ...}: {
  flake.homeModules.opencode = {...}: {
    imports = [inputs.mcp-servers-nix.flakeModule];

    home.programs.opencode = {
      enable = true;
      settings = {
        theme = "Nord";
        model = "anthropic/claude-sonnet-4-20250514";
        autoshare = false;
        autoupdate = true;
      };
    };

    mcp-servers = {
      programs.playwright.enable = true;
    };
  };
}
