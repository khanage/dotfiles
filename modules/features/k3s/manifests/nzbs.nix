_: {
  "1-sabnzb-deployment".content = {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "sabnzb";
      namespace = "default";
    };
    spec = {
      replicas = 1;
      selector = {
        matchLabels = {
          app = "sabnzb";
        };
      };
      template = {
        metadata = {
          labels = {
            app = "sabnzb";
          };
        };
        spec = {
          volumes = [
            {
              name = "sabnzb-config";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/sabnzb/config";
              };
            }
            {
              name = "downloads-incomplete";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/sabnzb/incomplete";
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
              name = "sabnzb";
              image = "lscr.io/linuxserver/sabnzbd:latest";
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
              ];
              ports = [
                {containerPort = 8080;}
              ];
              volumeMounts = [
                {
                  name = "sabnzb-config";
                  mountPath = "/config";
                }
                {
                  name = "downloads";
                  mountPath = "/downloads";
                }
                {
                  name = "downloads-incomplete";
                  mountPath = "/incomplete-downloads";
                }
              ];
            }
          ];
        };
      };
    };
  };

  "2-sabnzb-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "sabnzb";
      namespace = "default";
    };
    spec = {
      selector = {
        app = "sabnzb";
      };
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 8080;
          targetPort = 8080;
        }
      ];
      type = "ClusterIP";
    };
  };

  "3-sabnzb-ingress".content = {
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
