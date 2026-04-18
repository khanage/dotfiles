_: {
  flake.homeModules.shell = {pkgs, ...}: {
    home.packages = with pkgs; [
      starship
      lsd
      fd
      ripgrep
      lazygit
      xh
      pavucontrol
      imagemagick
      kubectl
    ];

    programs = {
      zsh = {
        enable = true;
        oh-my-zsh = {
          enable = true;
          plugins = ["git" "direnv" "fzf" "vi-mode"];
        };
        shellAliases = let
          dotfiles = "~/dotfiles";
        in {
          ls = "lsd -A";
          vim = "nvim";
          cat = "bat";
          vdf = "vim --cmd ':cd ${dotfiles}/' ${dotfiles}/modules/home/default.nix ${dotfiles}/modules/hosts/homepc/configuration.nix";
          nfu = "git -C ${dotfiles} pull && sudo nix flake update --flake ${dotfiles}";
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

      bat = {
        enable = true;
        config = {
          theme = "Nord";
          pager = "";
        };
      };

      opencode = {
        enable = true;
        settings = {
          theme = "Nord";
          model = "anthropic/claude-sonnet-4-20250514";
          autoshare = false;
          autoupdate = true;
        };
      };
    };
  };
}
