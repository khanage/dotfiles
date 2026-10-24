_: {
  "1-jackett-deployment".content = {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "jackett";
      namespace = "default";
    };
    spec = {
      replicas = 1;
      selector = {
        matchLabels = {
          app = "jackett";
        };
      };
      template = {
        metadata = {
          labels = {
            app = "jackett";
          };
        };
        spec = {
          volumes = [
            {
              name = "jackett-config";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/jackett";
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
              name = "jackett";
              image = "lscr.io/linuxserver/jackett:latest";
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
                  name = "AUTO_UPDATE";
                  value = "false";
                }
              ];
              ports = [
                {containerPort = 9117;}
              ];
              volumeMounts = [
                {
                  name = "jackett-config";
                  mountPath = "/config";
                }
                {
                  name = "downloads";
                  mountPath = "/downloads";
                }
              ];
              livenessProbe = {
                httpGet = {
                  path = "/health";
                  port = 9117;
                };
                initialDelaySeconds = 30;
                periodSeconds = 10;
              };
            }
          ];
        };
      };
    };
  };

  "2-jackett-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "jackett";
      namespace = "default";
    };
    spec = {
      selector = {
        app = "jackett";
      };
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 9117;
          targetPort = 9117;
        }
      ];
      type = "ClusterIP";
    };
  };

  "3-jackett-ingress".content = {
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
