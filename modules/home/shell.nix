{...}: {
  flake.homeModules.shell = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [starship lsd fzf];
    programs.zsh = {
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
  };
}

