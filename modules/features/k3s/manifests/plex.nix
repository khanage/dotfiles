_: {
  "2-plex-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "plex";
      namespace = "default";
    };
    spec = {
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 32400;
          targetPort = 32400;
        }
      ];
    };
  };

  "3-plex-endpoints".content = {
    apiVersion = "v1";
    kind = "Endpoints";
    metadata = {
      name = "plex";
      namespace = "default";
    };
    subsets = [
      {
        addresses = [{ip = "192.168.1.171";}];
        ports = [
          {
            name = "http";
            port = 32400;
            protocol = "TCP";
          }
        ];
      }
    ];
  };

  "4-plex-ingress".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "plex";
      namespace = "default";
    };
    spec = {
      entryPoints = ["websecure"];
      tls = {};
      routes = [
        {
          match = "Host(`plex.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "plex";
              namespace = "default";
              port = 32400;
            }
          ];
        }
      ];
    };
  };
}
