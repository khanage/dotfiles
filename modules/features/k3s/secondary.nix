_: {
  flake.nixosModules.k8s_secondary = {
    pkgs,
    config,
    k8sconfig,
    ...
  }: {
    services.k3s = {
      enable = true;
      role = "server";
      tokenFile = config.sops.secrets.k8s_token.path;
      serverAddr = "https://${k8sconfig.server_addr}:6443";
      extraFlags = ["--debug"];
      package = pkgs.k3s_1_34;
    };
  };
}
