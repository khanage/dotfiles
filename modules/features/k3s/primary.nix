_: {
  flake.nixosModules.k8s_primary = {
    pkgs,
    config,
    ...
  }: {
    services.k3s = {
      enable = true;
      role = "server";
      tokenFile = config.sops.secrets.k8s_token.path;
      clusterInit = true;
      extraFlags = ["--debug" "--write-kubeconfig-mode=644"];
      package = pkgs.k3s_1_34;
    };
  };
}
