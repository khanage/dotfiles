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
    home.file.".config/opencode/AGENTS.md".text = ''
      ## Environments and dependencies

      This system uses nix with direnv for all dependencies. The configuration is stored at ~/dotfiles regardless of the host.

      - ALWAYS use a devshell loaded via direnv/.envrc with "use flake"
      - If there is no .envrc at a project root, ask to create a new flake.nix, call the devshell with .envrc, and add the flake.nix to git.
      - Run `direnv allow` if needed.
      - ALWAYS use the project flake.nix to add dependencies or introduce new tools to the command line
    '';
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
              "--user-data-dir"
              "${config.xdg.stateHome}/playwright/user-data"
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
