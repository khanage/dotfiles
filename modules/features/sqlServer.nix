_: {
  flake.darwinModules.sqlServer = _: {
    environment.etc."krb5.conf" = {
      # mode = "0644";
      # user = "root";
      # group = "wheel";
      source = /run/secrets/krb5_conf;
    };
  };
}
