_: {
  "0-prowlarr-config-pvc".content = {
    apiVersion = "v1";
    kind = "PersistentVolumeClaim";
    metadata = {
      name = "prowlarr-config";
      namespace = "default";
    };
    spec = {
      accessModes = ["ReadWriteMany"];
      storageClassName = "nfs";
      resources.requests.storage = "1Gi";
    };
  };

  "1-prowlarr-deployment".content = {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "prowlarr";
      namespace = "default";
    };
    spec = {
      replicas = 1;
      selector = {
        matchLabels = {
          app = "prowlarr";
        };
      };
      template = {
        metadata = {
          labels = {
            app = "prowlarr";
          };
        };
        spec = {
          volumes = [
            {
              name = "prowlarr-config";
              persistentVolumeClaim = {
                claimName = "prowlarr-config";
              };
            }
          ];
          containers = [
            {
              name = "prowlarr";
              image = "lscr.io/linuxserver/prowlarr:latest";
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
                {containerPort = 9696;}
              ];
              volumeMounts = [
                {
                  name = "prowlarr-config";
                  mountPath = "/config";
                }
              ];
            }
          ];
        };
      };
    };
  };

  "2-prowlarr-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "prowlarr";
      namespace = "default";
    };
    spec = {
      selector = {
        app = "prowlarr";
      };
      ports = [
        {
          protocol = "TCP";
          port = 9696;
          targetPort = 9696;
        }
      ];
      type = "ClusterIP";
    };
  };

  "3-prowlarr-ingress".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "prowlarr";
      namespace = "default";
    };
    spec = {
      entryPoints = ["websecure"];
      tls = {};
      routes = [
        {
          match = "Host(`prowlarr.home.khanage.net`)";
          kind = "Rule";
          services = [
            {
              name = "prowlarr";
              namespace = "default";
              port = 9696;
            }
          ];
        }
      ];
    };
  };
}
