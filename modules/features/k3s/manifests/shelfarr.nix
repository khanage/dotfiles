_: {
  "1-shelfarr-deployment".content = {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "shelfarr";
      namespace = "default";
    };
    spec = {
      replicas = 1;
      selector = {
        matchLabels = {
          app = "shelfarr";
        };
      };
      template = {
        metadata = {
          labels = {
            app = "shelfarr";
          };
        };
        spec = {
          volumes = [
            {
              name = "shelfarr-config";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/shelfarr";
              };
            }
            {
              name = "media-library";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/";
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
              name = "shelfarr";
              image = "ghcr.io/pedro-revez-silva/shelfarr:latest";
              env = [
                {
                  name = "RAILS_ENV";
                  value = "production";
                }
                {
                  name = "SOLID_QUEUE_IN_PUMA";
                  value = "1";
                }
                {
                  name = "HTTP_PORT";
                  value = "5056";
                }
              ];
              ports = [
                {containerPort = 5056;}
              ];
              volumeMounts = [
                {
                  name = "shelfarr-config";
                  mountPath = "/rails/storage";
                }
                {
                  name = "media-library";
                  mountPath = "/media";
                }
                {
                  name = "downloads";
                  mountPath = "/downloads";
                }
              ];
              livenessProbe = {
                httpGet = {
                  path = "/up";
                  port = 5056;
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

  "2-shelfarr-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "shelfarr";
      namespace = "default";
    };
    spec = {
      selector = {
        app = "shelfarr";
      };
      ports = [
        {
          protocol = "TCP";
          port = 5056;
          targetPort = 5056;
        }
      ];
      type = "ClusterIP";
    };
  };

  "3-shelfarr-ingress".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "shelfarr";
      namespace = "default";
    };
    spec = {
      entryPoints = ["websecure"];
      tls = {};
      routes = [
        {
          match = "Host(`books.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "shelfarr";
              namespace = "default";
              port = 5056;
            }
          ];
        }
      ];
    };
  };
}
