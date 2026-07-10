_: {
  # SSH client configuration.
  #
  # Provides a dedicated host alias for the personal (khanage) GitHub account
  # so it can be used alongside the work account without conflicting keys.
  #
  # The private key is decrypted by sops-nix to /run/secrets/github_personal_ssh_key
  # (declared in modules/features/sops.nix, encrypted in
  # secrets/common/github_personal_ssh.yaml).
  #
  # Public key (add this to https://github.com/settings/keys on the khanage account):
  #   ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINDy4fzvR5IuSk56fdGu23uJxjc9M9xOnReeT4pW8A6j khanage@gmail.com
  #
  # Usage: clone/set remotes with the `github.com-personal` host, e.g.
  #   git@github.com-personal:khanage/dotfiles.git
  flake.homeModules.ssh = _: {
    programs.ssh = {
      enable = true;

      settings."github.com-personal" = {
        hostname = "github.com";
        user = "git";
        identityFile = "/run/secrets/github_personal_ssh_key";
        identitiesOnly = true;
      };
    };
  };
}
