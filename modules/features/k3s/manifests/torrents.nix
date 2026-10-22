_: {
  "2-qbittorrent-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "qbittorrent";
      namespace = "default";
    };
    spec = {
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 8008;
          targetPort = 8008;
        }
      ];
    };
  };

  "3-qbittorrent-endpoints".content = {
    apiVersion = "v1";
    kind = "Endpoints";
    metadata = {
      name = "qbittorrent";
      namespace = "default";
    };
    subsets = [
      {
        addresses = [{ip = "192.168.1.171";}];
        ports = [
          {
            name = "http";
            port = 8008;
            protocol = "TCP";
          }
        ];
      }
    ];
  };

  "4-qbittorrent-ingress".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "qbittorrent";
      namespace = "default";
    };
    spec = {
      entryPoints = ["websecure"];
      tls = {};
      routes = [
        {
          match = "Host(`torrents.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "qbittorrent";
              namespace = "default";
              port = 8008;
            }
          ];
        }
      ];
    };
  };
}
