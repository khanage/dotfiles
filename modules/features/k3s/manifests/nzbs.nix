_: {
  "2-sabnzb-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "sabnzb";
      namespace = "default";
    };
    spec = {
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 8080;
          targetPort = 8080;
        }
      ];
    };
  };

  "3-sabnzb-endpoints".content = {
    apiVersion = "v1";
    kind = "Endpoints";
    metadata = {
      name = "sabnzb";
      namespace = "default";
    };
    subsets = [
      {
        addresses = [{ip = "192.168.1.171";}];
        ports = [
          {
            name = "http";
            port = 8080;
            protocol = "TCP";
          }
        ];
      }
    ];
  };

  "4-sabnzb-ingress".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "sabnzb";
      namespace = "default";
    };
    spec = {
      entryPoints = ["websecure"];
      tls = {};
      routes = [
        {
          match = "Host(`nzbs.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "sabnzb";
              namespace = "default";
              port = 8080;
            }
          ];
        }
      ];
    };
  };
}
