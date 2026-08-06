# Extension module for programs.herdr that adds a `plugins` list.
# Plugins are installed at home-manager activation time (not build time),
# so network access is available. Plugins not in the declared list are
# uninstalled on each activation.
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

    # Newline-separated list of declared repos for shell comparison.
    declaredRepos = lib.concatMapStrings (p: p.repo + "\n") cfg.plugins;
  in {
    options.programs.herdr.plugins = lib.mkOption {
      type = lib.types.listOf pluginType;
      default = [];
      description = ''
        List of herdr plugins to install via `herdr plugin install`.
        Installation happens during home-manager activation so network
        access is available (unlike nix build time). Any installed plugin
        whose source repo is not in this list will be uninstalled.
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
          runtimePath = lib.makeBinPath [pkgs.git pkgs.openssh];

          installCmds = lib.concatMapStrings (plugin: let
            refFlag =
              if plugin.ref != null
              then "--ref ${lib.escapeShellArg plugin.ref} "
              else "";
          in ''
            echo "herdr: installing plugin ${plugin.repo}"
            ${herdrBin} plugin install ${refFlag}${lib.escapeShellArg plugin.repo} --yes
          '') cfg.plugins;
        in ''
          export PATH="${runtimePath}:$PATH"
          export XDG_CONFIG_HOME="${config.xdg.configHome}"
          export XDG_DATA_HOME="${config.xdg.dataHome}"

          # Uninstall any installed plugin whose source repo is not in the declared list.
          while IFS=$'\t' read -r _id _owner _repo; do
            [ -z "$_id" ] && continue
            _source_repo="$_owner/$_repo"
            if ! printf '%s\n' ${lib.escapeShellArg declaredRepos} | grep -qxF "$_source_repo"; then
              echo "herdr: uninstalling $_id (not in declared plugins)"
              ${herdrBin} plugin uninstall "$_id" || true
            fi
          done < <(${herdrBin} plugin list --json | \
            ${jq} -r '.result.plugins[] | [.plugin_id, .source.owner, .source.repo] | @tsv')

          # Install declared plugins.
          ${installCmds}
        ''
      );
    };
  };
}
