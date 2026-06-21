_: {
  flake.homeModules.opencode = {
    pkgs,
    lib,
    config,
    ...
  }: let
    ai-dlc-rules = pkgs.fetchzip {
      url = "https://github.com/awslabs/aidlc-workflows/releases/download/v0.1.8/ai-dlc-rules-v0.1.8.zip";
      sha256 = "sha256-sufJZHpP76RWJSrsl+eHoNQuWGeyd8JOG0RYgsE3fa8=";
      stripRoot = false;
    };
    ado-mcp = pkgs.writeShellScriptBin "ado-mcp" ''
      export PATH=${pkgs.lib.makeBinPath [pkgs.nodejs_24 pkgs.azure-cli]}:$PATH
      exec ${pkgs.nodejs_24}/bin/npx -y @azure-devops/mcp "pointsbet" "$@"
    '';
    # Wrap github-mcp-server so the PAT is injected at launch time from the
    # sops-decrypted file (declared in modules/features/sops.nix). Keeps the
    # token out of the nix store and out of the rendered opencode.json.
    github-mcp = pkgs.writeShellScriptBin "github-mcp" ''
      token_file="/run/secrets/github_token"
      if [ ! -r "$token_file" ]; then
        echo "github-mcp: cannot read $token_file (is sops-nix activated?)" >&2
        exit 1
      fi
      export GITHUB_PERSONAL_ACCESS_TOKEN="$(cat "$token_file")"
      exec ${lib.getExe pkgs.github-mcp-server} stdio "$@"
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

      ## Global AGENTS.md

      This file (~/.config/opencode/AGENTS.md) is managed declaratively by home-manager.
      The source of truth is ~/dotfiles/modules/home/opencode.nix (home.file.".config/opencode/AGENTS.md".text).
      Do NOT edit ~/.config/opencode/AGENTS.md directly — changes will be overwritten on the next home-manager switch.
      To update these instructions, edit the nix file and rebuild.

      ## AI-DLC

      AI-DLC (AI-Driven Development Life Cycle) rules are managed by nix and available at:
      - ~/.config/opencode/ai-dlc/core-workflow.md  (core rules)
      - ~/.config/opencode/ai-dlc/rule-details/      (detailed rules)

      Use the /ai-dlc command to initialize a new AI-DLC project in a directory.
    '';

    home.file.".config/opencode/ai-dlc/core-workflow.md".source = "${ai-dlc-rules}/aidlc-rules/aws-aidlc-rules/core-workflow.md";

    home.file.".config/opencode/ai-dlc/rule-details".source = "${ai-dlc-rules}/aidlc-rules/aws-aidlc-rule-details";

    home.file.".config/opencode/commands/ai-dlc.md".text = ''
      ---
      description: Initialize a new AI-DLC project in a directory
      ---
      Initialize a new AI-DLC project in the directory: $ARGUMENTS

      Steps:
      1. Create the directory $ARGUMENTS if it doesn't exist
      2. Copy ~/.config/opencode/ai-dlc/core-workflow.md to $ARGUMENTS/AGENTS.md
      3. Copy the contents of ~/.config/opencode/ai-dlc/rule-details/ to $ARGUMENTS/.aidlc-rule-details/
      4. Confirm all files are in place and show the resulting directory structure
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
          github = {
            enabled = true;
            type = "local";
            command = "${lib.getExe github-mcp}";
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
          provider = {
            ollama = {
              models = {"gemma4:latest" = {};};
            };
          };
        };
        tui = {theme = "nord";};
      };
    };
  };
}
