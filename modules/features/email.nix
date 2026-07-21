_: {
  flake.nixosModules.email = {
    pkgs,
    lib,
    ...
  }: let
    mailspringDesktop = pkgs.makeDesktopItem {
      name = "mailspring";
      desktopName = "Mailspring";
      exec = "${lib.getExe pkgs.mailspring} --password-store=gnome-libsecret";
      comment = "Launch Mailspring";
      categories = ["Email" "Network"];
      terminal = false;
      type = "Application";
    };
  in {
    environment.systemPackages = [pkgs.mailspring mailspringDesktop];
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
