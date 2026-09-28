_: {
  flake.darwinModules.sqlServer = {config, ...}: {
    environment.etc."krb5.conf".source = config.sops.secrets.krb5_conf.path;
  };
}
