{inputs, ...}: {
  # NixOS-side sops module (shared by every NixOS host)
  flake.nixosModules.sops = {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops = {
      # Derive the host's age key from its SSH host key.
      # This means we don't have to manage a separate age key per host.
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

      # Disable GnuPG; we use age exclusively.
      gnupg.sshKeyPaths = [];
      secrets.wifi_password = {
        sopsFile = ../../secrets/homepc/wifi.yaml;
        format = "yaml";
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
    };
  };
}
