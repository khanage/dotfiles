_: {
  flake.nixosModules.k8s_primary = {
    pkgs,
    config,
    lib,
    ...
  }: {
    boot.supportedFilesystems = ["nfs"];
    environment.systemPackages = [pkgs.nfs-utils];
    services.k3s = {
      enable = true;
      role = "server";
      tokenFile = config.sops.secrets.k8s_token.path;
      clusterInit = true;
      extraFlags = ["--debug" "--write-kubeconfig-mode=644"];
      package = pkgs.k3s_1_34;
      manifests =
        {
          traefik-config.content = {
            apiVersion = "helm.cattle.io/v1";
            kind = "HelmChartConfig";
            metadata = {
              name = "traefik";
              namespace = "kube-system";
            };
            spec.valuesContent = ''
              api:
                dashboard: true
              metrics:
                prometheus:
                  enabled: true
                  addEntryPointLabels: true
                  addServicesLabels: true
              ports:
                metrics:
                  expose:
                    default: true
                  port: 9100
                  protocol: TCP
                traefik:
                  expose:
                    default: true
                  port: 9000
                  protocol: TCP
              dashboard:
                enabled: true
            '';
          };

          "01-nfs-provisioner".content = {
            apiVersion = "helm.cattle.io/v1";
            kind = "HelmChart";
            metadata = {
              name = "nfs-subdir-external-provisioner";
              namespace = "kube-system";
            };
            spec = {
              chart = "nfs-subdir-external-provisioner";
              repo = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner";
              targetNamespace = "kube-system";
              valuesContent = ''
                nfs:
                  server: 192.168.1.171
                  path: /volume1/docker
                storageClass:
                  name: nfs
                  defaultClass: false
                  reclaimPolicy: Retain
                  archiveOnDelete: false
              '';
            };
          };

          "02-cert-manager".content = {
            apiVersion = "helm.cattle.io/v1";
            kind = "HelmChart";
            metadata = {
              name = "cert-manager";
              namespace = "kube-system";
            };
            spec = {
              chart = "cert-manager";
              repo = "https://charts.jetstack.io";
              version = "v1.21.2";
              targetNamespace = "cert-manager";
              createNamespace = true;
              bootstrap = true;
              valuesContent = ''
                crds:
                  enabled: true
                  keep: true
              '';
            };
          };

          "03-spaceship-webhook".content = {
            apiVersion = "helm.cattle.io/v1";
            kind = "HelmChart";
            metadata = {
              name = "cert-manager-webhook-spaceship";
              namespace = "kube-system";
            };
            spec = {
              chart = "cert-manager-webhook-spaceship";
              repo = "https://hjwylde.github.io/cert-manager-webhook-spaceship";
              version = "0.1.3";
              targetNamespace = "cert-manager";
              createNamespace = true;
              bootstrap = true;
              valuesContent = ''
                certManager:
                  namespace: cert-manager
                  serviceAccountName: cert-manager
              '';
            };
          };

          "04-prometheus-stack".content = {
            apiVersion = "helm.cattle.io/v1";
            kind = "HelmChart";
            metadata = {
              name = "kube-prometheus-stack";
              namespace = "kube-system";
            };
            spec = {
              chart = "kube-prometheus-stack";
              repo = "https://prometheus-community.github.io/helm-charts";

              targetNamespace = "monitoring";
              createNamespace = true;

              bootstrap = true;
              valuesContent = ''
                prometheus:
                  prometheusSpec:
                    serviceMonitorNilUsesHelmValues: false
                kubeControllerManager:
                  enabled: false
                kubeScheduler:
                  enabled: false
                kubeProxy:
                  enabled: false
                grafana:
                  enabled: true
                prometheus-node-exporter:
                  service:
                    port: 9101
              '';
              valuesSecrets = [
                {
                  name = "grafana-helm-values";
                  namespace = "monitoring";
                }
              ];
            };
          };

          "50-traefik-dashboard".content = {
            apiVersion = "traefik.io/v1alpha1";
            kind = "IngressRoute";
            metadata = {
              name = "traefik-dashboard";
              namespace = "kube-system";
            };
            spec = {
              entryPoints = ["web"];
              routes = [
                {
                  match = "Host(`traefik.home.khanage.net`)";
                  kind = "Rule";
                  services = [
                    {
                      name = "api@internal";
                      kind = "TraefikService";
                    }
                  ];
                }
              ];
            };
          };

          "51-prometheus-ingress".content = {
            apiVersion = "traefik.io/v1alpha1";
            kind = "IngressRoute";
            metadata = {
              name = "prometheus";
              namespace = "monitoring";
            };
            spec = {
              entryPoints = ["web"];
              routes = [
                {
                  match = "Host(`prometheus.home.khanage.net`)";
                  kind = "Rule";
                  services = [
                    {
                      name = "kube-prometheus-stack-prometheus";
                      namespace = "monitoring";
                      port = 9090;
                    }
                  ];
                }
              ];
            };
          };

          "52-grafana-ingress".content = {
            apiVersion = "traefik.io/v1alpha1";
            kind = "IngressRoute";
            metadata = {
              name = "grafana";
              namespace = "monitoring";
            };
            spec = {
              entryPoints = ["web"];
              routes = [
                {
                  match = "Host(`grafana.home.khanage.net`)";
                  kind = "Rule";
                  services = [
                    {
                      name = "kube-prometheus-stack-grafana";
                      namespace = "monitoring";
                      port = 80;
                    }
                  ];
                }
              ];
            };
          };

          "99-traefik-monitor".content = {
            apiVersion = "monitoring.coreos.com/v1";
            kind = "ServiceMonitor";
            metadata = {
              name = "traefik-monitor";
              namespace = "monitoring";
              labels = {
                release = "kube-prometheus-stack";
              };
            };
            spec = {
              selector = {
                matchLabels = {
                  "app.kubernetes.io/name" = "traefik";
                  "app.kubernetes.io/instance" = "traefik-kube-system";
                };
              };
              namespaceSelector = {
                matchNames = ["kube-system"];
              };
              endpoints = [
                {
                  port = "metrics";
                  path = "/metrics";
                  interval = "30s";
                  honorLabels = true;
                }
              ];
            };
          };
        }
        // lib.mapAttrs' (
          name: value: lib.nameValuePair "1000-${name}" value
        ) (import ./manifests/shelfarr.nix {inherit config;})
        // lib.mapAttrs' (
          name: value: lib.nameValuePair "1001-${name}" value
        ) (import ./manifests/prowlarr.nix {inherit config;})
        // lib.mapAttrs' (
          name: value: lib.nameValuePair "1002-${name}" value
        ) (import ./manifests/certificates.nix {inherit config;});
    };
  };
}
