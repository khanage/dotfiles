_: {
  flake.homeModules.legacy = {pkgs, ...} @ inputs: {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home = {
      packages = with pkgs;
        [
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
          lsd
          fd
          ripgrep
          kdePackages.dolphin
          discord-ptb
          lazygit
          pavucontrol
          # freecad-wayland
          mesa-demos
          xh
          godot
          godot-export-templates-bin
          imagemagick
          gnomeExtensions.system-monitor-tray-indicator
          kubectl
          wl-clipboard
          cliphist
          polychromatic
          keymapp
          hypridle
          xivlauncher
          nodejs_latest
          texlive.combined.scheme-basic
          xwayland-satellite
          tree-sitter
          mermaid-cli
          ghostscript
          wowup-cf
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
          # bevy_cli.packakges.${pkgs.system}.bevy_cli
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
        ++ (with beam28Packages; [
          elixir
          elixir-ls
          erlang
        ]);

      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      file = {
        ".config/hypr/hyprland.conf".source = ./legacy/conf/hyprland.conf;
        ".config/hypr/hypridle.conf".source = ./legacy/conf/hypridle.conf;
        ".config/niri/config.kdl".source = ./legacy/conf/niri/config.kdl;
        ".config/opencode/opencode.json".text = ''
          { "$schema":"https://opencode.ai/tui.json", "theme": "nord"}
        '';
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
        nbs = "sudo nixos-rebuild switch --flake ${dotfiles} && git -C ${dotfiles} commit -am 'chore: sync dotfiles' && git -C ${dotfiles} push";
        nfu = "git -C ${dotfiles} pull && sudo nix flake update --flake ${dotfiles}";
        pushdots = "git -C ${dotfiles} commit -am 'chore: sync dotfiles' && git -C ${dotfiles} push";
        vdf = "vim --cmd ':cd ${dotfiles}/' ${dotfiles}/home-manager/home.nix";
        replace-commit = "${dotfiles}/.local/bin/replace-commit";
      };
    };

    # Let Home Manager install and manage itself.
    programs = {
      home-manager.enable = true;
      k9s.enable = true;
      bottom.enable = true;

      rofi = {
        enable = true;
        theme = "nord";
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
      };

      kitty = import ./legacy/kitty.nix inputs;

      git = {
        enable = true;
        settings = {
          user.name = "khanage";
          user.email = "khanage@gmail.com";
          init.defaultBranch = "main";
          credential.helper = "store";
          pull.ff = "only";
        };
      };

      hyprpanel = import ./legacy/hyprpanel.nix {};

      hyprlock = {
        enable = true;
      };

      fzf = {
        enable = true;
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      bat = {
        enable = true;
        config = {
          theme = "Nord";
          pager = "";
        };
      };

      # TODO: work out vscode
      # vscode = import ./legacy/vscode.nix {inherit pkgs;};

      opencode.enable = true;
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
  };
}
