# Extension module for programs.herdr that adds a `plugins` list.
# Plugins are installed at home-manager activation time (not build time),
# so network access is available. Plugins removed from the list are
# automatically uninstalled on the next activation.
_: {
  flake.homeModules.herdr = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.programs.herdr;

    pluginType = lib.types.submodule {
      options = {
        repo = lib.mkOption {
          type = lib.types.str;
          description = ''
            GitHub repository in the form <owner>/<repo>[/<subdir>].
            Passed directly to `herdr plugin install`.
          '';
          example = "ogulcancelik/herdr-browser";
        };

        ref = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Optional git ref (branch, tag, or commit SHA) to pin the plugin.";
          example = "main";
        };
      };
    };

    # Persists the plugin IDs installed by nix between activations so we
    # can uninstall anything that falls out of the declared list.
    stateFile = "${config.xdg.stateHome}/herdr/nix-managed-plugins";
  in {
    options.programs.herdr.plugins = lib.mkOption {
      type = lib.types.listOf pluginType;
      default = [];
      description = ''
        List of herdr plugins to install via `herdr plugin install`.
        Installation happens during home-manager activation so network
        access is available (unlike nix build time). Plugins removed
        from this list are uninstalled on the next activation.
      '';
      example = lib.literalExpression ''
        [
          { repo = "ogulcancelik/herdr-browser"; }
        ]
      '';
    };

    config = lib.mkIf cfg.enable {
      home.activation.herdrPlugins = lib.hm.dag.entryAfter ["writeBoundary"] (
        let
          herdrBin =
            if cfg.package != null
            then "${lib.getExe cfg.package}"
            else "${lib.getExe pkgs.herdr}";

          jq = "${pkgs.jq}/bin/jq";

          # herdr shells out to `git` (and git needs `ssh`). During home-manager
          # activation PATH is stripped, so we must provide these explicitly.
          runtimePath = lib.makeBinPath [pkgs.git pkgs.openssh pkgs.jq];

          installPlugin = plugin: let
            refFlag =
              if plugin.ref != null
              then " --ref ${lib.escapeShellArg plugin.ref}"
              else "";
          in ''
            echo "herdr: installing plugin ${plugin.repo}${refFlag}"
            ${herdrBin} plugin install ${lib.escapeShellArg plugin.repo}${refFlag} --yes
          '';

          installCmds = lib.concatMapStrings installPlugin cfg.plugins;
        in ''
          export PATH="${runtimePath}:$PATH"
          export XDG_CONFIG_HOME="${config.xdg.configHome}"
          export XDG_DATA_HOME="${config.xdg.dataHome}"

          _herdr_list_ids() {
            ${herdrBin} plugin list --json | ${jq} -r '.result.plugins[].plugin_id'
          }

          # Snapshot of nix-managed IDs from the previous activation.
          _prev_ids=""
          if [ -f ${lib.escapeShellArg stateFile} ]; then
            _prev_ids=$(cat ${lib.escapeShellArg stateFile})
          fi

          # Install / update all declared plugins.
          ${installCmds}

          # Snapshot of nix-managed IDs after this activation.
          _next_ids=$(_herdr_list_ids)

          # Uninstall anything that was managed by nix before but isn't now.
          if [ -n "$_prev_ids" ]; then
            while IFS= read -r _id; do
              [ -z "$_id" ] && continue
              if ! echo "$_next_ids" | grep -qxF "$_id"; then
                echo "herdr: uninstalling removed plugin $_id"
                ${herdrBin} plugin uninstall "$_id" || true
              fi
            done <<< "$_prev_ids"
          fi

          # Persist the current nix-managed set for the next activation.
          mkdir -p "$(dirname ${lib.escapeShellArg stateFile})"
          echo "$_next_ids" > ${lib.escapeShellArg stateFile}
        ''
      );
    };
  };
}
