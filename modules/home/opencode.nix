{inputs, ...}: {
  flake.homeModules.opencode = {...}: {
    imports = [inputs.mcp-servers-nix.homeManagerModules.default];

    programs.mcp.enable = true;
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        model = "anthropic/claude-sonnet-4-20250514";
        autoshare = false;
        autoupdate = false;
      };
      tui = {theme = "nord";};
    };
    mcp-servers.programs = {
      playwright.enable = true;
    };
  };
}
