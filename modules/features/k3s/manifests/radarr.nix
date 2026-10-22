_: {
  "2-radarr-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "radarr";
      namespace = "default";
    };
    spec = {
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 7878;
          targetPort = 7878;
        }
      ];
    };
  };

  "3-radarr-endpoints".content = {
    apiVersion = "v1";
    kind = "Endpoints";
    metadata = {
      name = "radarr";
      namespace = "default";
    };
    subsets = [
      {
        addresses = [{ip = "192.168.1.171";}];
        ports = [
          {
            name = "http";
            port = 7878;
            protocol = "TCP";
          }
        ];
      }
    ];
  };

  "4-radarr-ingress".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "radarr";
      namespace = "default";
    };
    spec = {
      entryPoints = ["websecure"];
      tls = {};
      routes = [
        {
          match = "Host(`movies.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "radarr";
              namespace = "default";
              port = 7878;
            }
          ];
        }
      ];
    };
  };
}
