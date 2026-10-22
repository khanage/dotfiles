_: {
  # "0-sonarr-config-pvc".content = {
  #   apiVersion = "v1";
  #   kind = "PersistentVolumeClaim";
  #   metadata = {
  #     name = "sonarr-config";
  #     namespace = "default";
  #   };
  #   spec = {
  #     accessModes = ["ReadWriteMany"];
  #     storageClassName = "nfs";
  #     resources.requests.storage = "1Gi";
  #   };
  # };
  #
  # "1-sonarr-deployment".content = {
  #   apiVersion = "apps/v1";
  #   kind = "Deployment";
  #   metadata = {
  #     name = "sonarr";
  #     namespace = "default";
  #   };
  #   spec = {
  #     replicas = 1;
  #     selector = {
  #       matchLabels = {
  #         app = "sonarr";
  #       };
  #     };
  #     template = {
  #       metadata = {
  #         labels = {
  #           app = "sonarr";
  #         };
  #       };
  #       spec = {
  #         volumes = [
  #           {
  #             name = "sonarr-config";
  #             persistentVolumeClaim = {
  #               claimName = "sonarr-config";
  #             };
  #           }
  #         ];
  #         containers = [
  #           {
  #             name = "sonarr";
  #             image = "lscr.io/linuxserver/sonarr:latest";
  #             env = [
  #               {
  #                 name = "PUID";
  #                 value = "1000";
  #               }
  #               {
  #                 name = "PGID";
  #                 value = "1000";
  #               }
  #               {
  #                 name = "TZ";
  #                 value = "Australia/Melbourne";
  #               }
  #             ];
  #             ports = [
  #               {containerPort = 9696;}
  #             ];
  #             volumeMounts = [
  #               {
  #                 name = "sonarr-config";
  #                 mountPath = "/config";
  #               }
  #             ];
  #           }
  #         ];
  #       };
  #     };
  #   };
  # };

  "2-sonarr-service".content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "sonarr";
      namespace = "default";
    };
    spec = {
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 8989;
          targetPort = 8989;
        }
      ];
    };
  };

  "3-sonarr-endpoints".content = {
    apiVersion = "v1";
    kind = "Endpoints";
    metadata = {
      name = "sonarr";
      namespace = "default";
    };
    subsets = [
      {
        addresses = [{ip = "192.168.1.171";}];
        ports = [
          {
            name = "http";
            port = 8989;
            protocol = "TCP";
          }
        ];
      }
    ];
  };

  "4-sonarr-ingress".content = {
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
