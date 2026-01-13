{
  enable = true;
  settings = {
    bar = {
      customModules.storage.paths = ["/"];
      layouts = {
        "*" = {
          left = ["dashboard" "workspaces"];
          middle = ["media" "clock" "windowtitle"];
          right = ["volume" "weather" "cpu" "ram" "systray" "notifications"];
        };
      };

      autoHide = "fullscreen";
      location = "top";
      workspaces.showIcons = true;
      launcher.autoDetectIcon = true;
    };

    menus.clock = {
      weather = {
        unit = "metric";
        key = "9846e4e60b0f45519c9234645252211";
        location = "-37.8892,145.0571";
      };
      time = {
        military = true;
        hideSeconds = true;
      };
    };

    media.showActiveOnly = true;

    theme.mutagen = false;

    theme = {
      bar = {
        floating = true;
        location = "bottom";

        background = "#2e3440";
        border.color = "#88c0d0";
        buttons = {
          background = "#3b4252";
          hover = "#434c53";
          icon = "#88c0d0";
          icon_background = "#3b4252";
          borderColor = "#88c0d0";

          battery = {
            background = "#3b4252";
            border = "#81a1c1";
            hover = "#504945";
            icon = "#81a1c1";
            icon_background = "#81a1c1";
            text = "#81a1c1";
          };
          bluetooth = {
            background = "#3b4252";
            border = "#88c0d0";
            hover = "#504945";
            icon = "#88c0d0";
            icon_background = "#89dbeb";
            text = "#88c0d0";
          };
          clock = {
            background = "#3b4252";
            border = "#8fbcbb";
            hover = "#504945";
            icon = "#8fbcbb";
            icon_background = "#8fbcbb";
            text = "#8fbcbb";
          };
          dashboard = {
            background = "#3b4252";
            border = "#81a1c1";
            hover = "#504945";
            icon = "#81a1c1";
          };
          media = {
            background = "#3b4252";
            border = "#88c0d0";
            hover = "#504945";
            icon = "#88c0d0";
            icon_background = "#88c0d0";
            text = "#88c0d0";
          };
          modules = {
            cava = {
              background = "#3b4252";
              border = "#8fbcbb";
              icon = "#8fbcbb";
              icon_background = "#3b4252";
              text = "#8fbcbb";
            };
            cpu = {
              background = "#3b4252";
              border = "#8fbcbb";
              hover = "#45475a";
              icon = "#8fbcbb";
              icon_background = "#8fbcbb";
              text = "#8fbcbb";
            };
            cpuTemp = {
              border = "#fab387";
              icon = "#fab387";
              icon_background = "#fab387";
              text = "#fab387";
            };
            hypridle = {
              background = "#3b4252";
              border = "#8fbcbb";
              icon = "#8fbcbb";
              icon_background = "#8fbcbb";
              text = "#8fbcbb";
            };
            hyprsunset = {
              background = "#3b4252";
              border = "#81a1c1";
              icon = "#81a1c1";
              icon_background = "#81a1c1";
              text = "#81a1c1";
            };
            kbLayout = {
              background = "#3b4252";
              border = "#88c0d0";
              icon = "#88c0d0";
              icon_background = "#88c0d0";
              text = "#88c0d0";
            };
            microphone = {
              background = "#3b4252";
              border = "#8fbcbb";
              icon = "#8fbcbb";
              icon_background = "#3b4252";
              text = "#8fbcbb";
            };
            netstat = {
              background = "#3b4252";
              border = "#8fbcbb";
              icon = "#8fbcbb";
              icon_background = "#8fbcbb";
              text = "#8fbcbb";
            };
            power = {
              background = "#3b4252";
              border = "#8fbcbb";
              icon = "#8fbcbb";
              icon_background = "#8fbcbb";
            };
            ram = {
              background = "#3b4252";
              border = "#81a1c1";
              icon = "#81a1c1";
              icon_background = "#81a1c1";
              text = "#81a1c1";
            };
            storage = {
              background = "#3b4252";
              border = "#8fbcbb";
              icon = "#8fbcbb";
              icon_background = "#8fbcbb";
              text = "#8fbcbb";
            };
            submap = {
              background = "#3b4252";
              border = "#8fbcbb";
              icon = "#8fbcbb";
              icon_background = "#3b4252";
              text = "#8fbcbb";
            };
            updates = {
              background = "#3b4252";
              border = "#88c0d0";
              icon = "#88c0d0";
              icon_background = "#88c0d0";
              text = "#88c0d0";
            };
            weather = {
              background = "#3b4252";
              border = "#88c0d0";
              icon = "#88c0d0";
              icon_background = "#88c0d0";
              text = "#88c0d0";
            };
            worldclock = {
              background = "#3b4252";
              border = "#8fbcbb";
              icon = "#8fbcbb";
              icon_background = "#8fbcbb";
              text = "#8fbcbb";
            };
          };
          network = {
            background = "#3b4252";
            border = "#88c0d0";
            hover = "#504945";
            icon = "#88c0d0";
            icon_background = "#caa6f7";
            text = "#88c0d0";
          };
          notifications = {
            background = "#3b4252";
            border = "#88c0d0";
            hover = "#504945";
            icon = "#88c0d0";
            icon_background = "#88c0d0";
            total = "#88c0d0";
          };
          style = "default";
          text = "#88c0d0";
          systray = {
            background = "#3b4252";
            border = "#434c53";
            customIcon = "#d8dee9";
            hover = "#504945";
          };
          volume = {
            background = "#3b4252";
            border = "#81a1c1";
            hover = "#504945";
            icon = "#81a1c1";
            icon_background = "#81a1c1";
            input_icon = "#11111b";
            input_text = "#eba0ac";
            output_icon = "#11111b";
            output_text = "#eba0ac";
            separator = "#45475a";
            text = "#81a1c1";
          };
          windowtitle = {
            background = "#3b4252";
            border = "#8fbcbb";
            hover = "#504945";
            icon = "#8fbcbb";
            icon_background = "#8fbcbb";
            text = "#8fbcbb";
          };
          workspaces = {
            active = "#8fbcbb";
            available = "#88c0d0";
            background = "#3b4252";
            border = "#2e3440";
            hover = "#434c53";
            numbered_active_highlighted_text_color = "#21252b";
            numbered_active_text_color = "#24283b";
            numbered_active_underline_color = "#ffffff";
            occupied = "#81a1c1";
          };
        };
        menus = {
          background = "#2e3440";
          border.color = "#434c53";
          buttons.active = "#8fbcbb";
          buttons.default = "#88c0d0";
          buttons.disabled = "#434c53";
          buttons.text = "#2e3440";
          cards = "#3b4252";
          check_radio_button.active = "#88c0d0";
          check_radio_button.background = "#2e3440";
          dimtext = "#6272a4";
          dropdownmenu.background = "#2e3440";
          dropdownmenu.divider = "#3b4252";
          dropdownmenu.text = "#d8dee9";
          feinttext = "#434c53";
          iconbuttons.active = "#88c0d0";
          iconbuttons.passive = "#d8dee9";
          icons.active = "#88c0d0";
          icons.passive = "#434c53";
          label = "#88c0d0";
          listitems.active = "#88c0d0";
          listitems.passive = "#d8dee9";
          menu = {
            battery = {
              background.color = "#2e3440";
              border.color = "#434c53";
              card.color = "#3b4252";
              icons.active = "#81a1c1";
              icons.passive = "#5e81ac";
              label.color = "#81a1c1";
              listitems.active = "#81a1c1";
              listitems.passive = "#d8dee9";
              slider.background = "#434c53";
              slider.backgroundhover = "#434c53";
              slider.primary = "#81a1c1";
              slider.puck = "#4c566a";
              text = "#d8dee9";
            };
            bluetooth = {
              background.color = "#2e3440";
              border.color = "#434c53";
              card.color = "#3b4252";
              iconbutton.active = "#88c0d0";
              iconbutton.passive = "#d8dee9";
              icons.active = "#88c0d0";
              icons.passive = "#5e81ac";
              label.color = "#88c0d0";
              listitems.active = "#88c0d0";
              listitems.passive = "#d8dee9";
              scroller.color = "#88c0d0";
              status = "#4c566a";
              switch.disabled = "#434c53";
              switch.enabled = "#88c0d0";
              switch.puck = "#434c53";
              switch_divider = "#434c53";
              text = "#d8dee9";
            };
            clock = {
              background.color = "#2e3440";
              border.color = "#434c53";
              calendar = {
                contextdays = "#434c53";
                currentday = "#8fbcbb";
                days = "#d8dee9";
                paginator = "#8fbcbb";
                weekdays = "#8fbcbb";
                yearmonth = "#8fbcbb";
              };
              card.color = "#3b4252";
              text = "#d8dee9";
              time.time = "#8fbcbb";
              time.timeperiod = "#8fbcbb";
              weather = {
                hourly.icon = "#8fbcbb";
                hourly.temperature = "#8fbcbb";
                hourly.time = "#8fbcbb";
                icon = "#8fbcbb";
                stats = "#8fbcbb";
                status = "#8fbcbb";
                temperature = "#d8dee9";
                thermometer = {
                  cold = "#88c0d0";
                  extremelycold = "#88c0d0";
                  extremelyhot = "#8fbcbb";
                  hot = "#81a1c1";
                  moderate = "#88c0d0";
                };
              };
            };
            dashboard = {
              background.color = "#2e3440";
              border.color = "#434c53";
              card.color = "#3b4252";
              controls = {
                bluetooth.background = "#88c0d0";
                bluetooth.text = "#2e3440";
                disabled = "#434c53";
                input.background = "#8fbcbb";
                input.text = "#2e3440";
                notifications.background = "#81a1c1";
                notifications.text = "#2e3440";
                volume.background = "#81a1c1";
                volume.text = "#2e3440";
                wifi.background = "#88c0d0";
                wifi.text = "#2e3440";
              };
              directories = {
                left.bottom.color = "#81a1c1";
                left.middle.color = "#81a1c1";
                left.top.color = "#8fbcbb";
                right.bottom.color = "#88c0d0";
                right.middle.color = "#88c0d0";
                right.top.color = "#8fbcbb";
              };
              monitors = {
                bar_background = "#434c53";
                cpu.bar = "#81a1c1";
                cpu.icon = "#81a1c1";
                cpu.label = "#81a1c1";
                disk.bar = "#8fbcbb";
                disk.icon = "#8fbcbb";
                disk.label = "#8fbcbb";
                gpu.bar = "#8fbcbb";
                gpu.icon = "#8fbcbb";
                gpu.label = "#8fbcbb";
                ram.bar = "#81a1c1";
                ram.icon = "#81a1c1";
                ram.label = "#81a1c1";
              };
              powermenu = {
                confirmation = {
                  background = "#2e3440";
                  body = "#d8dee9";
                  border = "#434c53";
                  button_text = "#2e3440";
                  card = "#3b4252";
                  confirm = "#8fbcbb";
                  deny = "#8fbcbb";
                  label = "#88c0d0";
                };
                logout = "#8fbcbb";
                restart = "#81a1c1";
                shutdown = "#8fbcbb";
                sleep = "#88c0d0";
              };
              profile.name = "#8fbcbb";
              shortcuts.background = "#88c0d0";
              shortcuts.recording = "#8fbcbb";
              shortcuts.text = "#2e3440";
            };
            media = {
              album = "#8fbcbb";
              artist = "#8fbcbb";
              background.color = "#2e3440";
              border.color = "#434c53";
              buttons.background = "#88c0d0";
              buttons.enabled = "#8fbcbb";
              buttons.inactive = "#434c53";
              buttons.text = "#2e3440";
              card.color = "#3b4252";
              slider.background = "#434c53";
              slider.backgroundhover = "#434c53";
              slider.primary = "#8fbcbb";
              slider.puck = "#4c566a";
              song = "#88c0d0";
              timestamp = "#d8dee9";
            };
            network = {
              background.color = "#2e3440";
              border.color = "#434c53";
              card.color = "#3b4252";
              iconbuttons.active = "#88c0d0";
              iconbuttons.passive = "#d8dee9";
              icons.active = "#88c0d0";
              icons.passive = "#5e81ac";
              label.color = "#88c0d0";
              listitems.active = "#88c0d0";
              listitems.passive = "#d8dee9";
              scroller.color = "#88c0d0";
              status.color = "#4c566a";
              switch.disabled = "#434c53";
              switch.enabled = "#88c0d0";
              switch.puck = "#434c53";
              text = "#d8dee9";
            };
            notifications = {
              background = "#2e3440";
              border = "#434c53";
              card = "#3b4252";
              clear = "#8fbcbb";
              label = "#88c0d0";
              no_notifications_label = "#434c53";
              pager.background = "#2e3440";
              pager.button = "#88c0d0";
              pager.label = "#5e81ac";
              scrollbar.color = "#88c0d0";
              switch.disabled = "#434c53";
              switch.enabled = "#88c0d0";
              switch.puck = "#434c53";
              switch_divider = "#434c53";
            };
            power = {
              background.color = "#2e3440";
              border.color = "#434c53";
              buttons = {
                logout.background = "#3b4252";
                logout.icon = "#2e3440";
                logout.icon_background = "#8fbcbb";
                logout.text = "#8fbcbb";
                restart.background = "#3b4252";
                restart.icon = "#2e3440";
                restart.icon_background = "#81a1c1";
                restart.text = "#81a1c1";
                shutdown.background = "#3b4252";
                shutdown.icon = "#2e3440";
                shutdown.icon_background = "#8fbcbb";
                shutdown.text = "#8fbcbb";
                sleep.background = "#3b4252";
                sleep.icon = "#2e3440";
                sleep.icon_background = "#88c0d0";
                sleep.text = "#88c0d0";
              };
              card.color = "#2a283e";
            };
            systray.dropdownmenu = {
              background = "#2e3440";
              divider = "#3b4252";
              text = "#d8dee9";
            };
            volume = {
              audio_slider = {
                background = "#434c53";
                backgroundhover = "#434c53";
                primary = "#81a1c1";
                puck = "#434c53";
              };
              background.color = "#2e3440";
              border.color = "#434c53";
              card.color = "#3b4252";
              iconbutton.active = "#81a1c1";
              iconbutton.passive = "#d8dee9";
              icons.active = "#81a1c1";
              icons.passive = "#5e81ac";
              input_slider = {
                background = "#434c53";
                backgroundhover = "#434c53";
                primary = "#81a1c1";
                puck = "#434c53";
              };
              label.color = "#81a1c1";
              listitems.active = "#81a1c1";
              listitems.passive = "#d8dee9";
              text = "#d8dee9";
            };
          };
          popover = {
            background = "#2e3440";
            border = "#2e3440";
            text = "#88c0d0";
          };
          progressbar.background = "#434c53";
          progressbar.foreground = "#88c0d0";
          slider.background = "#434c53";
          slider.backgroundhover = "#434c53";
          slider.primary = "#88c0d0";
          slider.puck = "#4c566a";
          switch.disabled = "#434c53";
          switch.enabled = "#88c0d0";
          switch.puck = "#434c53";
          text = "#d8dee9";
          tooltip.background = "#2e3440";
          tooltip.text = "#d8dee9";
        };
      };
      notification = {
        actions.background = "#88c0d0";
        actions.text = "#2e3440";
        background = "#2e3440";
        border = "#434c53";
        close_button.background = "#8fbcbb";
        close_button.label = "#2e3440";
        label = "#88c0d0";
        labelicon = "#88c0d0";
        text = "#d8dee9";
        time = "#4c566a";
      };
      osd = {
        bar_color = "#88c0d0";
        bar_container = "#2e3440";
        bar_empty_color = "#434c53";
        bar_overflow_color = "#8fbcbb";
        border.color = "#8ff0a4";
        icon = "#2e3440";
        icon_container = "#88c0d0";
        label = "#88c0d0";
      };
    };
  };
}
