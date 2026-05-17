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
          vdf = "vim --cmd ':cd ${dotfiles}/' ${dotfiles}/modules/home/default.nix ${dotfiles}/modules/hosts/homepc/configuration.nix";
          nfu = "git -C ${dotfiles} pull && sudo nix flake update --flake ${dotfiles}";
          pushdots = "git -C ${dotfiles} commit -am 'chore: sync dotfiles' && git -C ${dotfiles} push";
          replace-commit = "${dotfiles}/.local/bin/replace-commit";
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

      k9s.enable = true;
      bottom.enable = true;

      starship = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
