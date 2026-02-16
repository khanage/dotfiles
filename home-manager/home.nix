{pkgs, ...}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "khan";
    homeDirectory = "/home/khan";

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
    packages = with pkgs;
      [
        spotify
        cargo
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
        freecad-wayland
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
        dotnet-sdk_10
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
      ".config/hypr/hyprland.conf".source = ./conf/hyprland.conf;
      ".config/hypr/hypridle.conf".source = ./conf/hypridle.conf;
      ".config/niri/config.kdl".source = ./conf/niri/config.kdl;
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
      nfu = "sudo nix flake update --flake ${dotfiles}";
      pushdots = "git -C ${dotfiles} commit -am 'chore: sync dotfiles' && git -C ${dotfiles} push";
      vdf = "vim --cmd ':cd ${dotfiles}/' ${dotfiles}/home-manager/home.nix";
      replace-commit = "${dotfiles}/.local/bin/replace-commit";
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    noctalia-shell = import ./noctalia.nix {};
    wofi = import ./wofi.nix;
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

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "direnv" "fzf" "vi-mode"];
      };
      shellAliases = {
        ls = "lsd -A";
        vim = "nvim";
        cat = "bat";
      };
    };

    kitty = import ./kitty.nix pkgs;

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

    hyprpanel = import ./hyprpanel.nix {};

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

    nvf = import ./nvf.nix pkgs;

    bat = {
      enable = true;
      config = {
        theme = "Nord";
        pager = "";
      };
    };
  };
}
