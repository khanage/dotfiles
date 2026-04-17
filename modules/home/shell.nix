_: {
  flake.homeModules.shell = {pkgs, ...}: {
    home.packages = with pkgs; [starship lsd];
    programs.zsh = {
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
  };
}
