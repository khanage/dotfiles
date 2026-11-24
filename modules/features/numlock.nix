_: {
  flake.nixosModules.numlockOn = {pkgs, ...}: {
    systemd.services.numlock-on = {
      description = "Enable Num Lock before the TTY login prompt";
      wantedBy = ["getty@tty1.service"];
      before = ["getty@tty1.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.kbd}/bin/setleds -D +num";
        StandardInput = "tty";
        TTYPath = "/dev/tty1";
      };
    };
  };
}
