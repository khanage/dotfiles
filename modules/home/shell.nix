_: {
  flake.homeModules.shell = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      lsd
      fd
      ripgrep
      lazygit
      xh
      imagemagick
      kubectl
      sops
      age
      ffmpeg
      gh
      dig
      gnupg
      apm-cli
      dust
    ];

    programs = {
      zsh = {
        enable = true;
        oh-my-zsh = {
          enable = true;
          plugins = ["git" "direnv" "fzf" "vi-mode" "fnm"];
        };
        shellAliases = let
          dotfiles = "~/dotfiles";
        in {
          ls = "lsd -A";
          vim = "nvim";
          cat = "bat";
          vdf = "vim --cmd ':cd ${dotfiles}/' ${dotfiles}/modules/home/shell.nix";
          nfu = ''
            git -C ${dotfiles} pull \
            && sudo nix flake update \
              --flake ${dotfiles}\
              --option warn-dirty false
          '';
          pushdots = "git -C ${dotfiles} commit -am 'chore: sync dotfiles' && git -C ${dotfiles} push";
          replace-commit = "${dotfiles}/.local/bin/replace-commit";
          clanker = "ollama launch opencode --model gemma4:26b";
        };
        initContent = ''
          eval "$(${lib.getExe pkgs.fnm} env --use-on-cd)"
        '';
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

      k9s = {
        enable = true;
        skins = {
          nord = ./k9s/nord.yaml;
        };
        settings = {
          k9s = {
            skipLatestRevCheck = true;
            ui = {
              skin = "nord";
            };
          };
        };
      };

      bottom = {
        enable = true;
        settings = {
          styles = {
            theme = "nord";
          };
        };
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
      };

      # Custom plugin support in herdr.nix
      herdr = {
        enable = true;
        settings = {
          onboarding = false;
          keys = {
            prefix = "ctrl+;";
            switch_workspace = "prefix+1..9";
            focus_agent = "prefix+shift+1..9";
            switch_tab = "prefix+alt+1..9";
          };
          theme.name = "nord";
          update = {
            version_check = false;
            manifest_check = false;
          };
          experimental.kitty_graphics = true;
          ui.sound.path = ../../resources/ambient_bridge_5.mp3;
        };
        plugins = [
          {
            repo = "paulbkim-dev/vim-herdr-navigation";
            ref = "820d48f5d9c9a7dece6a4bebfa3982ec30bbfbb7";
          }
        ];
      };

      ghostty =
        {
          enable = true;
          enableZshIntegration = true;
          settings = {
            theme = "Nord";
            auto-update = "off";
            font-family = "GoMono Nerd Font Mono";
          };
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          package = pkgs.ghostty-bin;
          settings = {
            macos-window-buttons = "hidden";
          };
        };

      gpg.enable = true;
    };
  };
}
