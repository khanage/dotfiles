_: {
  flake.homeModules.legacy = {pkgs, ...}: {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home = {
      packages = with pkgs;
        [
          pavucontrol
          cargo
          cargo-generate
          cargo-watch
          rustc
          rust-analyzer
          rustfmt
          clippy
          pkg-config
          openssl
          gcc
          godot
          godot-export-templates-bin
          gnomeExtensions.system-monitor-tray-indicator
          wl-clipboard
          cliphist
          polychromatic
          keymapp
          hypridle
          nodejs_latest
          xwayland-satellite
          tree-sitter
          mermaid-cli
          ghostscript
          razergenie
          egl-wayland
          nix-inspect
          pear-desktop
          (with pkgs.dotnetCorePackages;
            combinePackages [
              sdk_6_0
              sdk_8_0
              sdk_9_0 # Or combinePackages [sdk_8_0_1xx] for specific subversions
              sdk_10_0
            ])
          blender
          pulseaudio
          # # You can also create simple shell scripts directly inside your
          # # configuration. For example, this adds a command 'my-hello' to your
          # # environment:
          # (pkgs.writeShellScriptBin "my-hello" ''
          #   echo "Hello, ${config.home.username}!"
          # '')
        ]
        ++ (with haskellPackages; [
          ghc
          cabal-install
          haskell-language-server
          cabal2nix
          hoogle
          fast-tags
          ghci-dap
          haskell-debug-adapter
        ])
        ++ (with beamPackages; [
          elixir
          elixir-ls
          erlang
        ]);

      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      file = {
        ".config/hypr/hyprland.conf".source = ../conf/hyprland.conf;
        ".config/hypr/hypridle.conf".source = ../conf/hypridle.conf;
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
        QT_QPA_PLATFORM = "wayland";
      };

      shellAliases = let
        dotfiles = "~/dotfiles";
      in {
        ls = "lsd -A";
        nbs = ''
          sudo nixos-rebuild switch \
            --flake ${dotfiles} \
            --option warn-dirty false \
          && git -C ${dotfiles} commit -am 'chore: sync dotfiles'\
          && git -C ${dotfiles} push
        '';
      };
    };

    # Let Home Manager install and manage itself.
    programs = {
      home-manager.enable = true;
      thunderbird = {
        enable = true;
      };

      git = {
        enable = true;
        settings = {
          user = {
            name = "khanage";
            email = "khanage@gmail.com";
            signingkey = "/run/secrets/github_personal_ssh_key";
          };
          init.defaultBranch = "main";
          credential.helper = "store";
          pull.ff = "only";
          push.autoSetupRemote = true;
          commit.gpgsign = true;
          tag.gpgsign = true;

          # Force SSH for anything on github.com so the personal key
          # (declared on the `github.com` block in modules/home/ssh.nix)
          # is always used. Longest-prefix `insteadOf` semantics mean
          # this only rewrites when nothing more specific matches.
          "url \"git@github.com:\"".insteadOf = "https://github.com/";

          gpg = {
            format = "ssh";
            program = "${pkgs.gnupg}/bin/gpg";
            ssh.allowedSignersFile = toString (pkgs.writeText "khanage-allower-signers" ''
              khanage@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINDy4fzvR5IuSk56fdGu23uJxjc9M9xOnReeT4pW8A6j
            '');
          };
        };
      };

      hyprlock = {
        enable = true;
      };
    };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/about" = ["firefox.desktop"];
        "x-scheme-handler/unknown" = ["firefox.desktop"];
        "x-scheme-handler/mailto" = ["Mailspring.desktop"];
      };
      associations.added = {
        "x-scheme-handler/mailto" = ["Mailspring.desktop"];
      };
    };
  };
}
