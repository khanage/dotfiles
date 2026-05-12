{inputs, ...}: {
  flake.homeModules.opencode = {
    pkgs,
    lib,
    ...
  }: let
    ado-mcp = pkgs.writeShellScriptBin "ado-mcp" ''
      export PATH=${pkgs.lib.makeBinPath [pkgs.nodejs_20 pkgs.azure-cli]}:$PATH
      exec ${pkgs.nodejs_20}/bin/npx -y @azure-devops/mcp "pointsbet" "$@"
    '';
  in {
    programs = {
      mcp = {
        enable = true;
        servers = {
          azure-devops = {
            type = "local";
            command = "${lib.getExe ado-mcp}";
            enabled = true;
          };
          atlassian = {
            type = "remote";
            url = "https://mcp.atlassian.com/v1/sse";
            enabled = true;
          };
          playwright = {
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
            enable = true;
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
