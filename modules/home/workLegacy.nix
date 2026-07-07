{inputs, ...}: {
  flake.homeModules.workLegacy = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.paneru.homeModules.paneru
    ];

    fonts.fontconfig.enable = true;

    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home = {
      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      stateVersion = "25.05"; # Please read the comment before changing.

      # The home.packages option allows you to install Nix packages into your
      # environment.
      packages = with pkgs; [
        pkg-config
        openssl
        gcc
        nerd-fonts.iosevka-term
        nerd-fonts.go-mono
        azure-cli
        powershell
        fnm
        tree-sitter
        cargo
        clippy
        rustc
        rustfmt
        rust-analyzer
        cargo-generate
        (with pkgs.dotnetCorePackages;
          combinePackages [
            sdk_6_0
            sdk_8_0
            sdk_9_0 # Or combinePackages [sdk_8_0_1xx] for specific subversions
            sdk_10_0
          ])
        # haskellPackages.cabal
        # haskellPackages.hoogle
        # haskellPackages.haskell-debug-adapter
      ];

      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      file = {
        ".hammerspoon/init.lua".source = ./legacy/conf/hammerspoon.lua;
      };

      # Home Manager can also manage your environment variables through
      # 'home.sessionVariables'. These will be explicitly sourced when using a
      # shell provided by Home Manager. If you don't want to manage your shell
      # through Home Manager then you have to manually source 'hm-session-vars.sh'
      # located at either
      #
      #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  /etc/profiles/per-user/khan/etc/profile.d/hm-session-vars.sh
      #
      sessionVariables = {
        EDITOR = "nvim";
        DOCKER_DEFAULT_PLATFORM = "linux/amd64";
      };

      # Import the sops-decrypted GPG signing key into the user keyring so
      # git can sign commits. sops-nix (darwin system module) decrypts the
      # armored private key to /run/secrets/gpg_private_key during system
      # activation; this runs afterwards and imports it idempotently.
      activation.importGpgSigningKey =
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          keyFile="/run/secrets/gpg_private_key"
          fpr="D7165CC734B85E82C754CA319F45EFB1E16BDC6F"
          if [ -r "$keyFile" ]; then
            if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys "$fpr" >/dev/null 2>&1; then
              $DRY_RUN_CMD ${pkgs.gnupg}/bin/gpg --batch --import "$keyFile"
              # Mark the key ultimately trusted so gpg doesn't warn on sign.
              $DRY_RUN_CMD ${pkgs.gnupg}/bin/gpg --batch --import-ownertrust <<EOF
$fpr:6:
EOF
            fi
          else
            echo "warning: $keyFile not found; skipping GPG key import" >&2
          fi
        '';
    };

    # Let Home Manager install and manage itself.
    programs = {
      home-manager.enable = true;
      zsh = {
        shellAliases = let
          dotfiles = "~/dotfiles";
        in {
          nbs = "sudo darwin-rebuild switch --flake ${dotfiles} && brew upgrade && git -C ${dotfiles} commit -am 'chore: sync dotfiles' && git -C ${dotfiles} push";
        };
      };

      git = {
        enable = true;
        settings = {
          user.name = "Khan Thompson";
          user.email = "khan.thompson@pointsbet.com";
          user.signingkey = "9F45EFB1E16BDC6F";
          init.defaultBranch = "main";
          credential.helper = "store";
          push.autoSetupRemote = true;
          pull.rebase = true;
          commit.gpgsign = true;
          tag.gpgsign = true;
          gpg.program = "${pkgs.gnupg}/bin/gpg";
        };

        # Use the personal (khanage) GitHub identity for any repo under
        # ~/dotfiles/. This is rendered with mkAfter (see home-manager's
        # git module), so it is appended *after* the [user] block above and
        # therefore wins the include precedence. Overrides the work identity
        # and disables GPG signing (the work key would make khanage commits
        # show as Unverified on GitHub). Authentication uses the personal SSH
        # key via the `github.com-personal` host alias (modules/home/ssh.nix).
        includes = [
          {
            condition = "gitdir:~/dotfiles/";
            contents = {
              user = {
                name = "khanage";
                email = "khanage@gmail.com";
              };
              commit.gpgsign = false;
              tag.gpgsign = false;
            };
          }
        ];
      };
    };

    services.paneru = {
      enable = false;
      # Equivalent to what you would put into `~/.paneru` (See Configuration options below).
      settings = {
        options = {
          focus_follows_mouse = false;
          preset_column_widths = [
            0.25
            0.33
            0.5
            0.66
            0.75
          ];
          swipe_gesture_fingers = 4;
          animation_speed = 400;
          border_active_window = true;
          border_color = "7fc8ff";
        };
        bindings = {
          window_focus_west = "ctrl - h";
          window_focus_east = "ctrl - l";
          window_focus_north = "ctrl - k";
          window_focus_south = "ctrl - j";
          window_swap_west = "alt - h";
          window_swap_east = "alt - l";
          window_swap_first = "alt + shift - h";
          window_swap_last = "alt + shift - l";
          window_center = "alt - c";
          window_resize = "alt - r";
          window_fullwidth = "alt - f";
          window_manage = "ctrl + alt - t";
          window_stack = "alt - ]";
          window_unstack = "alt + shift - ]";
          quit = "ctrl + alt - q";
        };
        windows = {
          all = {
            title = ".*";
            horizontal_padding = 4;
            vertical_padding = 4;
          };
          reminders = {
            title = "[0-9]* Reminders?";
            dont_focus = true;
            floating = true;
          };
        };
      };
    };
  };
}
