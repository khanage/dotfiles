_: {
  "2-jackett-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "jackett";
      namespace = "default";
    };
    spec = {
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 9117;
          targetPort = 9117;
        }
      ];
    };
  };

  "3-jackett-endpoints".content = {
    apiVersion = "v1";
    kind = "Endpoints";
    metadata = {
      name = "jackett";
      namespace = "default";
    };
    subsets = [
      {
        addresses = [{ip = "192.168.1.171";}];
        ports = [
          {
            name = "http";
            port = 9117;
            protocol = "TCP";
          }
        ];
      }
    ];
  };

  "4-jackett-ingress".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "jackett";
      namespace = "default";
    };
    spec = {
      entryPoints = ["websecure"];
      tls = {};
      routes = [
        {
          match = "Host(`jackett.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "jackett";
              namespace = "default";
              port = 9117;
            }
          ];
        }
      ];
    };
  };
}
