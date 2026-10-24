_: {
  "1-plex-deployment".content = {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "plex";
      namespace = "default";
    };
    spec = {
      replicas = 1;
      selector = {
        matchLabels = {
          app = "plex";
        };
      };
      template = {
        metadata = {
          labels = {
            app = "plex";
          };
        };
        spec = {
          nodeSelector = {
            "kubernetes.io/hostname" = "thebrain";
          };
          volumes = [
            {
              name = "plex-config";
              hostPath = {
                path = "/plex";
                type = "DirectoryOrCreate";
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
              name = "tv";
              nfs = {
                server = "192.168.1.171";
                path = "/volume1/docker/tv";
              };
            }
            {
              name = "dri";
              hostPath = {
                path = "/dev/dri";
                type = "Directory";
              };
            }
          ];
          containers = [
            {
              name = "plex";
              image = "lscr.io/linuxserver/plex:latest";
              securityContext = {
                privileged = true;
                allowPrivilegeEscalation = true;
              };
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
                  name = "ADVERTISE_IP";
                  value = "http://192.168.1.43:32400/";
                }
                {
                  name = "VERSION";
                  value = "docker";
                }
                {
                  name = "PLEX_CLAIM";
                  valueFrom = {
                    secretKeyRef = {
                      name = "plex-claim";
                      key = "plex_claim";
                    };
                  };
                }
              ];
              ports = [
                {containerPort = 32400;}
                {
                  containerPort = 1900;
                  protocol = "UDP";
                }
                {
                  containerPort = 5353;
                  protocol = "UDP";
                }
                {containerPort = 8324;}
                {
                  containerPort = 32410;
                  protocol = "UDP";
                }
                {
                  containerPort = 32412;
                  protocol = "UDP";
                }
                {
                  containerPort = 32413;
                  protocol = "UDP";
                }
                {
                  containerPort = 32414;
                  protocol = "UDP";
                }
                {containerPort = 32469;}
              ];
              startupProbe = {
                httpGet = {
                  path = "/identity";
                  port = 32400;
                };
                periodSeconds = 10;
                failureThreshold = 30;
              };
              readinessProbe = {
                httpGet = {
                  path = "/identity";
                  port = 32400;
                };
                periodSeconds = 10;
                timeoutSeconds = 5;
              };
              livenessProbe = {
                httpGet = {
                  path = "/identity";
                  port = 32400;
                };
                periodSeconds = 30;
                timeoutSeconds = 5;
              };
              volumeMounts = [
                {
                  name = "plex-config";
                  mountPath = "/config";
                }
                {
                  name = "tv";
                  mountPath = "/tv";
                }
                {
                  name = "movies";
                  mountPath = "/movies";
                }
                {
                  name = "dri";
                  mountPath = "/dev/dri";
                }
              ];
            }
          ];
        };
      };
    };
  };

  "2-plex-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "plex";
      namespace = "default";
    };
    spec = {
      selector = {
        app = "plex";
      };
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 32400;
          targetPort = 32400;
          nodePort = 32400;
        }
      ];
      type = "NodePort";
    };
  };

  "3-plex-ingress".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "plex";
      namespace = "default";
    };
    spec = {
      entryPoints = ["websecure"];
      tls = {};
      routes = [
        {
          match = "Host(`plex.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "plex";
              namespace = "default";
              port = 32400;
            }
          ];
        }
      ];
    };
  };
}
