# Extension module for programs.herdr that adds a `plugins` list.
# Plugins are installed at home-manager activation time (not build time),
# so network access is available.
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
  in {
    options.programs.herdr.plugins = lib.mkOption {
      type = lib.types.listOf pluginType;
      default = [];
      description = ''
        List of herdr plugins to install via `herdr plugin install`.
        Installation happens during home-manager activation so network
        access is available (unlike nix build time).
      '';
      example = lib.literalExpression ''
        [
          { repo = "ogulcancelik/herdr-browser"; }
        ]
      '';
    };

    config = lib.mkIf (cfg.enable && cfg.plugins != []) {
      home.activation.herdrPlugins = lib.hm.dag.entryAfter ["writeBoundary"] (
        let
          herdrBin =
            if cfg.package != null
            then "${lib.getExe cfg.package}"
            else "${lib.getExe pkgs.herdr}";

          # herdr shells out to `git` (and git needs `ssh`). During home-manager
          # activation PATH is stripped, so we must provide these explicitly.
          runtimePath = lib.makeBinPath [pkgs.git pkgs.openssh];

          installPlugin = plugin: let
            refFlag =
              if plugin.ref != null
              then " --ref ${lib.escapeShellArg plugin.ref}"
              else "";
          in ''
            echo "herdr: installing plugin ${plugin.repo}${refFlag}"
            PATH="${runtimePath}:$PATH" \
              XDG_CONFIG_HOME="${config.xdg.configHome}" \
              XDG_DATA_HOME="${config.xdg.dataHome}" \
              ${herdrBin} plugin install ${lib.escapeShellArg plugin.repo}${refFlag} --yes
          '';

          installCmds =
            lib.concatMapStringsSep "\n" installPlugin cfg.plugins;
        in ''
          ${installCmds}
        ''
      );
    };
  };
}
