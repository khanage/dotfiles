{...}: {
  perSystem = {pkgs, ...}: {
    packages.myDiscord = pkgs.discord-ptb;
  };
}
