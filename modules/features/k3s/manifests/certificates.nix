_: {
  "0-letsencrypt-staging-issuer".content = {
    apiVersion = "cert-manager.io/v1";
    kind = "ClusterIssuer";
    metadata.name = "letsencrypt-staging";
    spec.acme = {
      email = "khanage@gmail.com";
      server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      privateKeySecretRef.name = "letsencrypt-staging-account";
      solvers = [
        {
          dns01.webhook = {
            groupName = "cert-manager-webhook-spaceship.hjwylde.github.io";
            solverName = "spaceship";
            config = {
              apiKeySecretRef = {
                name = "spaceship-credentials";
                key = "api-key";
              };
              apiSecretSecretRef = {
                name = "spaceship-credentials";
                key = "api-secret";
              };
            };
          };
        }
      ];
    };
  };

  "1-letsencrypt-production-issuer".content = {
    apiVersion = "cert-manager.io/v1";
    kind = "ClusterIssuer";
    metadata.name = "letsencrypt-production";
    spec.acme = {
      email = "khanage@gmail.com";
      server = "https://acme-v02.api.letsencrypt.org/directory";
      privateKeySecretRef.name = "letsencrypt-production-account";
      solvers = [
        {
          dns01.webhook = {
            groupName = "cert-manager-webhook-spaceship.hjwylde.github.io";
            solverName = "spaceship";
            config = {
              apiKeySecretRef = {
                name = "spaceship-credentials";
                key = "api-key";
              };
              apiSecretSecretRef = {
                name = "spaceship-credentials";
                key = "api-secret";
              };
            };
          };
        }
      ];
    };
  };

  "2-home-wildcard-staging-certificate".content = {
    apiVersion = "cert-manager.io/v1";
    kind = "Certificate";
    metadata = {
      name = "home-wildcard-staging";
      namespace = "default";
    };
    spec = {
      secretName = "home-wildcard-staging-tls";
      issuerRef = {
        name = "letsencrypt-staging";
        kind = "ClusterIssuer";
        group = "cert-manager.io";
      };
      dnsNames = ["*.home.khanage.net"];
    };
  };

  "3-home-wildcard-production-certificate".content = {
    apiVersion = "cert-manager.io/v1";
    kind = "Certificate";
    metadata = {
      name = "home-wildcard-production";
      namespace = "kube-system";
    };
    spec = {
      secretName = "home-wildcard-tls";
      issuerRef = {
        name = "letsencrypt-production";
        kind = "ClusterIssuer";
        group = "cert-manager.io";
      };
      dnsNames = ["*.home.khanage.net"];
    };
  };

  "4-traefik-default-tls-store".content = {
    apiVersion = "traefik.io/v1alpha1";
    kind = "TLSStore";
    metadata = {
      name = "default";
      namespace = "kube-system";
    };
    spec.defaultCertificate.secretName = "home-wildcard-tls";
  };
}
