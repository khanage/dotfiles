_: {
  flake.nixosModules.email = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = [pkgs.mailspring];
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    systemd.user.services.mailspring = {
      description = "Mailspring";
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.mailspring} --background --password-store='gnome-libsecret'";
        Restart = "on-failure";
      };
    };
  };
}
