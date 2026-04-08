{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        workspaces = {
          "default" = _: {};
          "games" = _: {};
          "chats" = _: {};
        };
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
          (lib.getExe pkgs.hypridle)
          "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store"
          "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store"
          (lib.getExe pkgs.kitty)
          (lib.getExe pkgs.firefox)
          (lib.getExe pkgs.discord-ptb)
          (lib.getExe pkgs.steam)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard = {
          xkb.layout = "us";
        };

        layout.gaps = 16;

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Q".close-window = _: {};
          "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
        };
      };
    };
  };
}
