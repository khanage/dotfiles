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
        # nbs = "sudo nixos-rebuild switch --flake ${dotfiles} && git -C ${dotfiles} commit -am 'chore: sync dotfiles' && git -C ${dotfiles} push";
        nbs = "sudo nixos-rebuild switch --flake ${dotfiles}";
        vdf = "vim --cmd ':cd ${dotfiles}/' ${dotfiles}/modules/home/default.nix ${dotfiles}/modules/hosts/homepc/configuration.nix";
        nfu = "git -C ${dotfiles} pull && sudo nix flake update --flake ${dotfiles}";
      };
    };
  };
}
