_: {
  flake.homeModules.opencode = {
    pkgs,
    lib,
    config,
    ...
  }: let
    ado-mcp = pkgs.writeShellScriptBin "ado-mcp" ''
      export PATH=${pkgs.lib.makeBinPath [pkgs.nodejs_24 pkgs.azure-cli]}:$PATH
      exec ${pkgs.nodejs_24}/bin/npx -y @azure-devops/mcp "pointsbet" "$@"
    '';
  in {
    programs = {
      mcp = {
        enable = true;
        servers = {
          azure-devops = {
            enabled = true;
            type = "local";
            command = "${lib.getExe ado-mcp}";
          };
          atlassian = {
            enabled = true;
            type = "remote";
            url = "https://mcp.atlassian.com/v1/sse";
          };
          playwright = {
            enable = true;
            type = "local";
            command = "${lib.getExe pkgs.playwright-mcp}";
            args = [
              "--executable-path"
              "${lib.getExe (
                if pkgs.stdenv.hostPlatform.isDarwin
                then pkgs.google-chrome
                else pkgs.chromium
              )}"
            ];
            env = {
              PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
              PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
            };
          };
        };
      };
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
  };
}
