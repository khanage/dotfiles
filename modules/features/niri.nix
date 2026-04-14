{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {pkgs, ...}: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

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
          "games" = _: {};
          "chats" = _: {};
        };

        window-rules = [
          {
            matches = [
              {
                app-id = "steam";
                at-startup = true;
              }
            ];
            open-on-workspace = "games";
          }
          {
            matches = [
              {
                app-id = "discord-ptb";
                at-startup = true;
              }
            ];
            open-on-workspace = "games";
          }
          {
            geometry-corner-radius = 20;
            clip-to-geometry = true;
          }
        ];

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

        gestures.hot-corners.off = _: {};

        layout = {
          gaps = 16;
          center-focused-column = "never";
        };

        environment = {
          QT_QPA_PLATFORM = "wayland";
        };

        hotkey-overlay.skip-at-startup = true;

        binds = {
          "Mod+T".spawn-sh = "${lib.getExe pkgs.kitty}";
          "Mod+Q".close-window = _: {};
          "Mod+Ctrl+Q".quit = _: {};
          "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";

          "Mod+O".toggle-overview = _: {};
          "Mod+Shift+Slash".show-hotkey-overlay = _: {};

          "Mod+F".maximize-column = _: {};
          "Mod+Shift+F".fullscreen-window = _: {};
          "Mod+C".center-column = _: {};
          "Mod+V".toggle-window-floating = _: {};

          "Mod+Left".focus-column-left = _: {};
          "Mod+Down".focus-window-down = _: {};
          "Mod+Up".focus-window-up = _: {};
          "Mod+Right".focus-column-right = _: {};
          "Mod+H".focus-column-left = _: {};
          "Mod+J".focus-window-down = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+L".focus-column-right = _: {};

          "Mod+Ctrl+Left".move-column-left = _: {};
          "Mod+Ctrl+Down".move-window-down = _: {};
          "Mod+Ctrl+Up".move-window-up = _: {};
          "Mod+Ctrl+Right".move-column-right = _: {};
          "Mod+Ctrl+H".move-column-left = _: {};
          "Mod+Ctrl+J".move-window-down = _: {};
          "Mod+Ctrl+K".move-window-up = _: {};
          "Mod+Ctrl+L".move-column-right = _: {};

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;
          "Mod+0".focus-workspace = 0;
          "Mod+Ctrl+1".move-column-to-workspace = 1;
          "Mod+Ctrl+2".move-column-to-workspace = 2;
          "Mod+Ctrl+3".move-column-to-workspace = 3;
          "Mod+Ctrl+4".move-column-to-workspace = 4;
          "Mod+Ctrl+5".move-column-to-workspace = 5;
          "Mod+Ctrl+6".move-column-to-workspace = 6;
          "Mod+Ctrl+7".move-column-to-workspace = 7;
          "Mod+Ctrl+8".move-column-to-workspace = 8;
          "Mod+Ctrl+9".move-column-to-workspace = 9;
          "Mod+Ctrl+0".move-column-to-workspace = 0;

          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          "XF86AudioMute".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ toggle";
        };
      };
    };
  };
}
