_: {
  "1-qbittorrent-deployment".content = {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "qbittorrent";
      namespace = "default";
    };
    spec = {
      replicas = 1;
      selector = {
        matchLabels = {
          app = "qbittorrent";
        };
      };
      template = {
        metadata = {
          labels = {
            app = "qbittorrent";
          };
        };
        spec = {
          volumes = [
            {
              name = "qbittorrent-config";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/qbittorrent";
              };
            }
            {
              name = "downloads";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/downloads";
              };
            }
          ];
          containers = [
            {
              name = "qbittorrent";
              image = "lscr.io/linuxserver/qbittorrent:latest";
              env = [
                {
                  name = "PUID";
                  value = "1000";
                }
                {
                  name = "PGID";
                  value = "1000";
                }
                {
                  name = "TZ";
                  value = "Australia/Melbourne";
                }
                {
                  name = "WEBUI_PORT";
                  value = "8008";
                }
                {
                  name = "TORRENTING_PORT";
                  value = "6881";
                }
              ];
              ports = [
                {containerPort = 8008;}
                {containerPort = 6881;}
                {
                  containerPort = 6881;
                  protocol = "UDP";
                }
              ];
              volumeMounts = [
                {
                  name = "qbittorrent-config";
                  mountPath = "/config";
                }
                {
                  name = "downloads";
                  mountPath = "/downloads";
                }
              ];
            }
          ];
        };
      };
    };
  };

  "2-qbittorrent-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "qbittorrent";
      namespace = "default";
    };
    spec = {
      selector = {
        app = "qbittorrent";
      };
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 8008;
          targetPort = 8008;
        }
      ];
      type = "ClusterIP";
    };
  };

  "3-qbittorrent-ingress".content = {
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
