{pkgs, ...}: {
  imports = [
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
      lsd
      fd
      ripgrep
      lazygit
      xh
      imagemagick
      kubectl
      nerd-fonts.iosevka-term
      nerd-fonts.go-mono
      dotnet-sdk
      azure-cli
      powershell
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      ".hammerspoon/init.lua".source = ./conf/hammerspoon.lua;
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

    shellAliases = let
      dotfiles = "~/dotfiles";
    in {
      ls = "lsd -A";
      nbs = "sudo darwin-rebuild switch --flake ${dotfiles}/test && git -C ${dotfiles} commit -am 'chore: update applied' && git -C ${dotfiles} push";
      nfu = "sudo nix flake update --flake ${dotfiles}/test";
      pushdots = "git -C ${dotfiles} commit -am 'chore: sync dotfiles' && git -C ${dotfiles} push";
      vdf = "vim --cmd ':cd ${dotfiles}/test/' ${dotfiles}/test/home-manager/work.nix";
      replace-commit = "${dotfiles}/.local/bin/replace-commit";
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    k9s.enable = true;
    bottom.enable = true;

    alacritty = {
      enable = true;
      theme = "Nord";
      settings = {
        font = {
          normal = {
            family = "GoMono Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "GoMono Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "GoMono Nerd Font Mono";
            style = "Italic";
          };
          bold_italic = {
            family = "GoMono Nerd Font Mono";
            style = "Bold Italic";
          };
          size = 12;
        };
      };
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
      ];
    };

    git = {
      enable = true;
      settings = {
        user.name = "Khan Thompson";
        user.email = "khan.thompson@pointsbet.com";
        init.defaultBranch = "main";
        credential.helper = "store";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };
    };

    fzf = {
      enable = true;
    };

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
}
