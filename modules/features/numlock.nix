_: {
  flake.nixosModules.numlockOn = {pkgs, ...}: {
    boot.initrd.systemd.services.numlock_on = {
      description = "Enable numlock in initrd";
      wantedBy = ["initrd.target"];
      before = ["initrd-root-device.target"];
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.kbd}/bin/setleds -D +num";
        StandardInput = "tty";
        TTYPath = "/dev/tty0";
      };
    };
  };
}
