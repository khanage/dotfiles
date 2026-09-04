{inputs, ...}: {
  # NixOS-side sops module (shared by every NixOS host)
  flake.nixosModules.sops = {config, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops = {
      # Derive the host's age key from its SSH host key.
      # This means we don't have to manage a separate age key per host.
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

      # Disable GnuPG; we use age exclusively.
      gnupg.sshKeyPaths = [];
      secrets."wifi_password" = {
        sopsFile = ../../secrets/homepc/wifi.yaml;
        format = "yaml";
      };
      templates."wifi-env" = {
        content = ''
          wifi_password=${config.sops.placeholder.wifi_password}
        '';
      };
      secrets."github_personal_ssh_key" = {
        sopsFile = ../../secrets/common/github_personal_ssh.yaml;
        format = "yaml";
        owner = "khan";
        mode = "0400";
      };
    };
  };

  flake.nixosModules.thebrainSops = {config, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops = {
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

      secrets."wifi_password" = {
        sopsFile = ../../secrets/homepc/wifi.yaml;
        format = "yaml";
      };
      templates."wifi-env" = {
        content = ''
          wifi_password=${config.sops.placeholder.wifi_password}
        '';
      };
      secrets."k8s_token" = {
        sopsFile = ../../secrets/homepc/k8s_token.yaml;
        format = "yaml";
      };
      secrets."grafana_admin_password" = {
        sopsFile = ../../secrets/homepc/grafana.yaml;
        format = "yaml";
      };
    };
  };

  flake.nixosModules.pinkySops = {config, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops = {
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

      secrets."wifi_password" = {
        sopsFile = ../../secrets/homepc/wifi.yaml;
        format = "yaml";
      };
      templates."wifi-env" = {
        content = ''
          wifi_password=${config.sops.placeholder.wifi_password}
        '';
      };
      secrets."k8s_token" = {
        sopsFile = ../../secrets/homepc/k8s_token.yaml;
        format = "yaml";
      };
      secrets."grafana_admin_password" = {
        sopsFile = ../../secrets/homepc/grafana.yaml;
        format = "yaml";
      };
      templates."grafana-helm-values" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: grafana-helm-values
            namespace: monitoring
          stringData:
            values.yaml: |
              grafana:
                adminPassword: ${config.sops.placeholder.grafana_admin_password}
        '';
        path = "/var/lib/rancher/k3s/server/manifests/grafana-helm-values-secret.yaml";
        mode = "0600";
      };
    };
  };

  # Darwin-side sops module. macOS doesn't auto-generate SSH host keys,
  # but they exist on this machine (created when Remote Login was toggled),
  # so we reuse the same approach as NixOS hosts.
  flake.darwinModules.sops = {
    imports = [inputs.sops-nix.darwinModules.sops];

    sops = {
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      gnupg.sshKeyPaths = [];

      # GitHub Personal Access Token for the github-mcp-server.
      # Encrypted file must contain a `github_token:` key.
      # Edit with: sops secrets/work/github.yaml
      secrets."github_token" = {
        sopsFile = ../../secrets/work/github.yaml;
        owner = "khanthompson";
        mode = "0400";
      };

      # GPG private key (armored) used to sign git commits.
      # Encrypted file must contain a `gpg_private_key:` key.
      # Decrypted to a file, then imported into the user keyring by a
      # home-manager activation script (see modules/home/workLegacy.nix).
      # Edit with: sops secrets/work/gpg.yaml
      secrets."gpg_private_key" = {
        sopsFile = ../../secrets/work/gpg.yaml;
        owner = "khanthompson";
        mode = "0400";
      };

      # Kerberos configuration for SQL Server authentication.
      # Encrypted file must contain a `krb5_conf` key.
      # Edit with: sops secrets/work/krb5.yaml
      secrets."krb5_conf" = {
        sopsFile = ../../secrets/work/krb5.yaml;
        owner = "khanthompson";
        mode = "0600";
      };

      # SSH private key for the personal (khanage) GitHub account.
      # Encrypted file must contain a `github_personal_ssh_key:` key.
      # Referenced as an IdentityFile by the personal github.com SSH host
      # (see modules/home/ssh.nix). Lives in secrets/common so both hosts
      # can decrypt it.
      # Edit with: sops secrets/common/github_personal_ssh.yaml
      secrets."github_personal_ssh_key" = {
        sopsFile = ../../secrets/common/github_personal_ssh.yaml;
        owner = "khanthompson";
        mode = "0400";
      };

      # Azure DevOps Personal Access Token for work.
      # Encrypted file must contain an `azure_devops_token:` key.
      # Edit with: sops secrets/work/azdo_pat.yaml
      secrets."azure_devops_token" = {
        sopsFile = ../../secrets/work/azdo_pat.yaml;
        owner = "khanthompson";
        mode = "0400";
      };

      # Jira API token for work (Atlassian).
      # Encrypted file must contain a `jira_api_key:` key.
      # Edit with: sops secrets/work/jira.yaml
      secrets."jira_api_key" = {
        sopsFile = ../../secrets/work/jira.yaml;
        owner = "khanthompson";
        mode = "0400";
      };

      # SSH private key for the PointsBet enterprise GitHub account.
      # Encrypted file must contain a `github_work_ssh_key:` key.
      # Referenced as an IdentityFile by the `github.com-work` SSH alias
      # host declared in modules/home/workLegacy.nix. URL rewrites in the
      # git config route any PointsBet / PointsBet-Price org URL through
      # that alias so this key is used for org repos only.
      # Edit with: sops secrets/work/github_work_ssh.yaml
      secrets."github_work_ssh_key" = {
        sopsFile = ../../secrets/work/github_work_ssh.yaml;
        owner = "khanthompson";
        mode = "0400";
      };
    };
  };
}
