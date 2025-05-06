{ config, pkgs, nixpkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  home.username = "khan";
  home.homeDirectory = "/home/khan";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    fortune
    kitty
    neovim
    firefox
    git
    bat
    ripgrep
    zig
    rustup
    fzf
    unzip
    nodejs_23
    clang
    lld
    pkg-config
    steam
    rofi
    dolphin
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
        ls = "ls -A --color";
        vim = "nvim";
        update = "sudo nixos-rebuild switch";
      };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
    initExtra = ''
    config() {
        git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME $@
      }
    config checkout -q
    config config status.showUntrackedFiles no
    '';
  };

  programs.git = {
    enable = true;
    extraConfig = {
       user.name = "Khan";
       user.email = "khanage@gmail.com";
       init.defaultBranch = "main";
    };
  };

  # programs.steam = {
  #     enable = true;
  # };
}
