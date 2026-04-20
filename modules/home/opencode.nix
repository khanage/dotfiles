{inputs, ...}: {
  flake.homeModules.opencode = {pkgs, ...}: {
    imports = [inputs.mcp-servers-nix.homeManagerModules.default];

    home.packages = with pkgs; [aks-mcp-server];

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
