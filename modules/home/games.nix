_: {
  flake.homeModules.gaming = {pkgs, ...}: let
    battlenet = pkgs.writeShellApplication {
      name = "battlenet-proton";
      runtimeInputs = [pkgs.umu-launcher];
      text = ''
        prefix="$HOME/Games/battlenet/pfx"
        launcher="$prefix/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"

        export WINEPREFIX="$prefix"
        export PROTONPATH="${pkgs.proton-ge-bin}"

        if [ "$#" -gt 0 ]; then
          exec umu-run "$@"
        fi

        if [ ! -f "$launcher" ]; then
          printf '%s\n' "Battle.net is not installed in $prefix." >&2
          printf '%s\n' "Download Battle.net-Setup.exe, then run: battlenet-proton ~/Downloads/Battle.net-Setup.exe" >&2
          exit 1
        fi

        exec umu-run "$launcher"
      '';
    };
    battlenetDesktop = pkgs.makeDesktopItem {
      name = "battlenet-proton";
      desktopName = "Battle.net";
      comment = "Launch Battle.net with GE-Proton";
      exec = "${battlenet}/bin/battlenet-proton";
      categories = ["Game" "Network"];
      terminal = false;
      type = "Application";
    };
  in {
    home.packages = with pkgs; [
      wowup-cf
      # xivlauncher
      discord-ptb
      battlenet
      battlenetDesktop
    ];
  };
}
