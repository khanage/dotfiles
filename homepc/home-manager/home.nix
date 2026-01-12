{pkgs, ...}: {
  imports = [
  ];

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
    packages = with pkgs; [
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
      flare-signal
      godot
      godot-export-templates-bin
      imagemagick
      gnomeExtensions.system-monitor-tray-indicator
      kubectl
      wl-clipboard
      cliphist
      beam28Packages.elixir
      beam28Packages.elixir-ls
      beam28Packages.erlang
      polychromatic
      keymapp
      hypridle
      xivlauncher
      nodejs_latest
      texlive.combined.scheme-basic
      # bevy_cli.packakges.${pkgs.system}.bevy_cli
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
      ".config/hypr/hyprland.conf".source = ./conf/hyprland.conf;
      ".config/hypr/hypridle.conf".source = ./conf/hypridle.conf;
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
      QT_QPA_PLATFORM = "xcb";
    };

    shellAliases = let
      dotfiles = "~/dotfiles";
    in {
      ls = "lsd -A";
      nbs = "sudo nixos-rebuild switch --flake ${dotfiles}/homepc";
      nfu = "sudo nix flake update --flake ${dotfiles}/homepc && git -C ${dotfiles} commit -am 'chore: update flake lock' && git -C ${dotfiles} push";
      pushdots = "git -C ${dotfiles} commit -am 'chore: sync dotfiles' && git -C ${dotfiles} push";
      vdf = "vim --cmd ':cd ${dotfiles}/homepc/' ${dotfiles}/homepc/home-manager/home.nix";
      replace-commit = "${dotfiles}/.local/bin/replace-commit";
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    wofi = {
      enable = true;
      style = ''
        * {
        	font-family: "Hack", monospace;
        }

        window {
        	background-color: #3B4252;
        }

        #input {
        	margin: 5px;
        	border-radius: 0px;
        	border: none;
        	background-color: #3B4252;
        	color: white;
        }

        #inner-box {
        	background-color: #383C4A;
        }

        #outer-box {
        	margin: 2px;
        	padding: 10px;
        	background-color: #383C4A;
        }

        #scroll {
        	margin: 5px;
        }

        #text {
        	padding: 4px;
        	color: white;
        }

        #entry:nth-child(even){
        	background-color: #404552;
        }

        #entry:selected {
        	background-color: #4C566A;
        }

        #text:selected {
        	background: transparent;
        }
      '';
    };
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
      plugins = [
        # {
        #   name = "powerlevel10k";
        #   src = pkgs.zsh-powerlevel10k;
        #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        # }
      ];
    };

    kitty = {
      enable = true;
      font = {
        name = "GoMono Nerd Font";
        size = 12;
      };
      themeFile = "Nord";
      settings = {
        copy_on_select = "clipboard";
      };
    };

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

    hyprpanel = import ./hyprpanel.nix;

    hyprlock = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    lutris.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    nvf = (import ./nvf.nix) pkgs;

    bat = {
      enable = true;
      config = {
        theme = "Nord";
        pager = "";
      };
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
      };
    };
  };
}
