_: {
  enable = true;
  settings = {
    bar = {
      position = "bottom";
      density = "spacious";
      showCapsule = false;
      floating = true;
      widgets = {
        left = [
          {id = "Launcher";}
          {id = "Workspace";}
          {id = "SystemMonitor";}
          {id = "MediaMini";}
        ];
        center = [
          {id = "ActiveWindow";}
          {id = "Taskbar";}
        ];
        right = [
          {id = "Tray";}
          {id = "NotificationHistory";}
          {id = "Volume";}
          {id = "Brightness";}
          {id = "Clock";}
          {id = "ControlCenter";}
        ];
      };
    };
    colorSchemes.predefinedScheme = "Nord";
    location = {
      name = "Melbourne, Australia";
    };
    wallpaper = {
      enabled = true;
      directory = "~/Pictures/Wallpapers";
    };
    appLauncher = {
      terminalCommand = "kitty";
    };
  };
}
