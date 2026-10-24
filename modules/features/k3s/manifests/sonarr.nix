_: {
  "1-sonarr-deployment".content = {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "sonarr";
      namespace = "default";
    };
    spec = {
      replicas = 1;
      selector = {
        matchLabels = {
          app = "sonarr";
        };
      };
      template = {
        metadata = {
          labels = {
            app = "sonarr";
          };
        };
        spec = {
          volumes = [
            {
              name = "sonarr-config";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/sonarr";
              };
            }
            {
              name = "tv";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/tv";
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
              name = "sonarr";
              image = "lscr.io/linuxserver/sonarr:latest";
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
                  name = "SONARR__SERVER__TRUSTEDNETWORKS";
                  value = "192.168.1.0/24,10.0.0.0/8";
                }
              ];
              ports = [
                {containerPort = 8989;}
              ];
              volumeMounts = [
                {
                  name = "sonarr-config";
                  mountPath = "/config";
                }
                {
                  name = "downloads";
                  mountPath = "/downloads";
                }
                {
                  name = "tv";
                  mountPath = "/tv";
                }
              ];
            }
          ];
        };
      };
    };
  };

  "2-sonarr-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "sonarr";
      namespace = "default";
    };
    spec = {
      selector = {
        app = "sonarr";
      };
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 8989;
          targetPort = 8989;
        }
      ];
      type = "ClusterIP";
    };
  };

  "3-sonarr-ingress".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "sonarr";
      namespace = "default";
    };
    spec = {
      entryPoints = ["websecure"];
      tls = {};
      routes = [
        {
          match = "Host(`tv.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "sonarr";
              namespace = "default";
              port = 8989;
            }
          ];
        }
        {
          match = "Host(`shows.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "sonarr";
              namespace = "default";
              port = 8989;
            }
          ];
        }
      ];
    };
  };
}
