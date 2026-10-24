_: {
  "1-radarr-deployment".content = {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "radarr";
      namespace = "default";
    };
    spec = {
      replicas = 1;
      selector = {
        matchLabels = {
          app = "radarr";
        };
      };
      template = {
        metadata = {
          labels = {
            app = "radarr";
          };
        };
        spec = {
          volumes = [
            {
              name = "radarr-config";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/radarr";
              };
            }
            {
              name = "movies";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/movies";
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
              name = "radarr";
              image = "lscr.io/linuxserver/radarr:latest";
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
                  name = "RADARR__SERVER__TRUSTEDNETWORKS";
                  value = "192.168.1.0/24,10.0.0.0/8";
                }
              ];
              ports = [
                {containerPort = 7878;}
              ];
              volumeMounts = [
                {
                  name = "radarr-config";
                  mountPath = "/config";
                }
                {
                  name = "downloads";
                  mountPath = "/downloads";
                }
                {
                  name = "movies";
                  mountPath = "/movies";
                }
              ];
            }
          ];
        };
      };
    };
  };

  "2-radarr-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "radarr";
      namespace = "default";
    };
    spec = {
      selector = {
        app = "radarr";
      };
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 7878;
          targetPort = 7878;
        }
      ];
      type = "ClusterIP";
    };
  };

  "3-radarr-ingress".content = {
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
