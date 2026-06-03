{self, ...}: {
  /*
  Steps to reinstall Battle.net on a fresh PC:
  1. Ensure Steam is set up with Proton 10 installed
  2. Add Battle.net as a non-Steam game in Steam pointing to a dummy exe (to generate an appid), then set compatibility to Proton 10
  3. Download the installer and run it through that appid:
  protontricks-launch --appid <appid> "/path/to/Battle.net-Setup.exe"
  4. Update the Steam shortcut to point to the installed Battle.net Launcher.exe
  The appid is auto-generated from the shortcut name — note it down once created (yours is 4194903326).
  */
  flake.homeModules.gaming = {pkgs, ...}: {
    home.packages = with pkgs; [
      wowup-cf
      xivlauncher
      discord-ptb
    ];
  };
}
