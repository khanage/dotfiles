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
          nfu = "git -C ${dotfiles} pull && sudo nix flake update --flake ${dotfiles}";
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

      herdr = {
        enable = true;
        settings = {
          keys.prefix = "ctrl+;";
          theme.name = "nord";
          update = {
            version_check = false;
            manifest_check = false;
          };
        };
      };

      ghostty =
        {
          enable = true;
          enableZshIntegration = true;
          settings = {
            theme = "Nord";
            auto-update = "off";
          };
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          package = pkgs.ghostty-bin;
          settings = {
            macos-window-buttons = "hidden";
          };
        };

      gpg.enable = true;
    };
  };
}
