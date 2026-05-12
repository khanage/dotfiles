{inputs, ...}: {
  flake.homeModules.opencode = {pkgs, ...}: let
    ado-mcp = pkgs.writeShellScriptBin "ado-mcp" ''
      export PATH=${pkgs.lib.makeBinPath [pkgs.nodejs_20 pkgs.azure-cli]}:$PATH
      exec ${pkgs.nodejs_20}/bin/npx -y @azure-devops/mcp "pointsbet" "$@"
    '';
  in {
    imports = [inputs.mcp-servers-nix.homeManagerModules.default];

    home = {packages = [ado-mcp];};

    programs = {
      mcp.enable = true;
      opencode = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          model = "anthropic/claude-sonnet-4-20250514";
          autoshare = false;
          autoupdate = false;
        };
        tui = {theme = "nord";};
      };
    };

    mcp-servers.programs.playwright.enable = true;
    mcp-servers.settings = {
      azure-devops = {
        type = "local";
        command = ["ado-mcp"];
        enabled = true;
      };
      atlassian = {
        type = "remote";
        url = "https://mcp.atlassian.com/v1/sse";
        enabled = true;
      };
    };
  };
}
