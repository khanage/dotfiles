_: {
  flake.nixosModules.discord = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [discord-ptb];
  };
}
