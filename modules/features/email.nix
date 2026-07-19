_: {
  flake.nixosModules.email = {pkgs, ...}: {
    environment.systemPackages = [pkgs.mailspring];
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
