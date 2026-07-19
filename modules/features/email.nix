_: {
  flake.nixosModules.email = {pkgs, ...}: {
    environment.systemPackages = [pkgs.mailspring];
  };
}
