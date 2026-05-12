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
    # The upstream playwright-mcp wrapper hardcodes PLAYWRIGHT_BROWSERS_PATH
    # to a read-only /nix/store path via `export`, which clobbers anything we
    # set in the MCP server `env`. Re-wrap the inner binary with `--set` so
    # our writable browsers path wins.
    playwright-mcp-writable = pkgs.symlinkJoin {
      name = "playwright-mcp-writable-${pkgs.playwright-mcp.version}";
      paths = [pkgs.playwright-mcp];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        rm -f $out/bin/playwright-mcp
        makeWrapper \
          ${pkgs.playwright-mcp}/bin/.playwright-mcp-wrapped \
          $out/bin/playwright-mcp \
          --set PLAYWRIGHT_BROWSERS_PATH "${config.xdg.stateHome}/playwright/browsers" \
          --set PLAYWRIGHT_MCP_BROWSER "chromium"
      '';
    };
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
            command = "${playwright-mcp-writable}/bin/playwright-mcp";
            args = [
              "--executable-path"
              "${lib.getExe (
                if pkgs.stdenv.hostPlatform.isDarwin
                then pkgs.google-chrome
                else pkgs.chromium
              )}"
            ];
            env = {
              PLAYWRIGHT_BROWSERS_PATH = "${config.xdg.stateHome}/playwright/browsers";
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
