_: {
  flake.darwinModules.sqlServer = _: {
    environment.etc."krb5.conf".source = /run/secrets/krb5_conf;
  };
}
