{pkgs, ...}: {
  imports = [
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "khan";
    homeDirectory = "/home/khan";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "25.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      spotify
      cargo
      rustc
      rust-analyzer
      rustfmt
      clippy
      pkg-config
      openssl
      gcc
      lsd
      fd
      ripgrep
      bat
      kdePackages.dolphin
      discord-ptb
      lazygit
      pavucontrol
      freecad-wayland
      mesa-demos
      xh
      flare-signal
      godot
      godot-export-templates-bin
      imagemagick
      gnomeExtensions.system-monitor-tray-indicator
      kubectl
      wl-clipboard
      cliphist
      # bevy_cli.packakges.${pkgs.system}.bevy_cli
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/khan/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      EDITOR = "nvim";
      QT_QPA_PLATFORM = "xcb";
    };

    shellAliases = {
      ls = "lsd -A";
      nbs = "sudo nixos-rebuild switch --flake ~/dotfiles/homepc";
      nfu = "sudo nix flake update --flake ~/dotfiles/homepc && git -C ~/dotfiles commit -am 'chore: update flake lock' && git -C ~/dotfiles push";
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    wofi = {
      enable = true;
      style = ''
        * {
        	font-family: "Hack", monospace;
        }

        window {
        	background-color: #3B4252;
        }

        #input {
        	margin: 5px;
        	border-radius: 0px;
        	border: none;
        	background-color: #3B4252;
        	color: white;
        }

        #inner-box {
        	background-color: #383C4A;
        }

        #outer-box {
        	margin: 2px;
        	padding: 10px;
        	background-color: #383C4A;
        }

        #scroll {
        	margin: 5px;
        }

        #text {
        	padding: 4px;
        	color: white;
        }

        #entry:nth-child(even){
        	background-color: #404552;
        }

        #entry:selected {
        	background-color: #4C566A;
        }

        #text:selected {
        	background: transparent;
        }
      '';
    };
    k9s.enable = true;
    bottom.enable = true;

    rofi = {
      enable = true;
      theme = "nord";
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "direnv" "fzf" "vi-mode"];
      };
      shellAliases = {
        ls = "lsd -A";
        vim = "nvim";
        cat = "bat";
      };
      plugins = [
        # {
        #   name = "powerlevel10k";
        #   src = pkgs.zsh-powerlevel10k;
        #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        # }
      ];
    };

    kitty = {
      enable = true;
      font = {
        name = "GoMono Nerd Font";
        size = 12;
      };
      themeFile = "tokyo_night_moon";
      settings = {
        copy_on_select = "clipboard";
      };
    };

    git = {
      enable = true;
      settings = {
        user.name = "khanage";
        user.email = "khanage@gmail.com";
        init.defaultBranch = "main";
        credential.helper = "store";
      };
    };

    hyprpanel = {
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
          location = "bottom";
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

        theme.bar = {
          floating = true;
          location = "bottom";
        };

        media.showActiveOnly = true;

        theme = {
          matugen = false;
          bar.menus.menu.notifications.scrollbar.color = "#88c0d0";
          bar.menus.menu.notifications.pager.label = "#5e81ac";
          bar.menus.menu.notifications.pager.button = "#88c0d0";
          bar.menus.menu.notifications.pager.background = "#2e3440";
          bar.menus.menu.notifications.switch.puck = "#434c53";
          bar.menus.menu.notifications.switch.disabled = "#434c53";
          bar.menus.menu.notifications.switch.enabled = "#88c0d0";
          bar.menus.menu.notifications.clear = "#8fbcbb";
          bar.menus.menu.notifications.switch_divider = "#434c53";
          bar.menus.menu.notifications.border = "#434c53";
          bar.menus.menu.notifications.card = "#3b4252";
          bar.menus.menu.notifications.background = "#2e3440";
          bar.menus.menu.notifications.no_notifications_label = "#434c53";
          bar.menus.menu.notifications.label = "#88c0d0";
          bar.menus.menu.power.buttons.sleep.icon = "#2e3440";
          bar.menus.menu.power.buttons.sleep.text = "#88c0d0";
          bar.menus.menu.power.buttons.sleep.icon_background = "#88c0d0";
          bar.menus.menu.power.buttons.sleep.background = "#3b4252";
          bar.menus.menu.power.buttons.logout.icon = "#2e3440";
          bar.menus.menu.power.buttons.logout.text = "#8fbcbb";
          bar.menus.menu.power.buttons.logout.icon_background = "#8fbcbb";
          bar.menus.menu.power.buttons.logout.background = "#3b4252";
          bar.menus.menu.power.buttons.restart.icon = "#2e3440";
          bar.menus.menu.power.buttons.restart.text = "#81a1c1";
          bar.menus.menu.power.buttons.restart.icon_background = "#81a1c1";
          bar.menus.menu.power.buttons.restart.background = "#3b4252";
          bar.menus.menu.power.buttons.shutdown.icon = "#2e3440";
          bar.menus.menu.power.buttons.shutdown.text = "#8fbcbb";
          bar.menus.menu.power.buttons.shutdown.icon_background = "#8fbcbb";
          bar.menus.menu.power.buttons.shutdown.background = "#3b4252";
          bar.menus.menu.power.border.color = "#434c53";
          bar.menus.menu.power.background.color = "#2e3440";
          bar.menus.menu.dashboard.monitors.disk.label = "#8fbcbb";
          bar.menus.menu.dashboard.monitors.disk.bar = "#8fbcbb";
          bar.menus.menu.dashboard.monitors.disk.icon = "#8fbcbb";
          bar.menus.menu.dashboard.monitors.gpu.label = "#8fbcbb";
          bar.menus.menu.dashboard.monitors.gpu.bar = "#8fbcbb";
          bar.menus.menu.dashboard.monitors.gpu.icon = "#8fbcbb";
          bar.menus.menu.dashboard.monitors.ram.label = "#81a1c1";
          bar.menus.menu.dashboard.monitors.ram.bar = "#81a1c1";
          bar.menus.menu.dashboard.monitors.ram.icon = "#81a1c1";
          bar.menus.menu.dashboard.monitors.cpu.label = "#81a1c1";
          bar.menus.menu.dashboard.monitors.cpu.bar = "#81a1c1";
          bar.menus.menu.dashboard.monitors.cpu.icon = "#81a1c1";
          bar.menus.menu.dashboard.monitors.bar_background = "#434c53";
          bar.menus.menu.dashboard.directories.right.bottom.color = "#88c0d0";
          bar.menus.menu.dashboard.directories.right.middle.color = "#88c0d0";
          bar.menus.menu.dashboard.directories.right.top.color = "#8fbcbb";
          bar.menus.menu.dashboard.directories.left.bottom.color = "#81a1c1";
          bar.menus.menu.dashboard.directories.left.middle.color = "#81a1c1";
          bar.menus.menu.dashboard.directories.left.top.color = "#8fbcbb";
          bar.menus.menu.dashboard.controls.input.text = "#2e3440";
          bar.menus.menu.dashboard.controls.input.background = "#8fbcbb";
          bar.menus.menu.dashboard.controls.volume.text = "#2e3440";
          bar.menus.menu.dashboard.controls.volume.background = "#81a1c1";
          bar.menus.menu.dashboard.controls.notifications.text = "#2e3440";
          bar.menus.menu.dashboard.controls.notifications.background = "#81a1c1";
          bar.menus.menu.dashboard.controls.bluetooth.text = "#2e3440";
          bar.menus.menu.dashboard.controls.bluetooth.background = "#88c0d0";
          bar.menus.menu.dashboard.controls.wifi.text = "#2e3440";
          bar.menus.menu.dashboard.controls.wifi.background = "#88c0d0";
          bar.menus.menu.dashboard.controls.disabled = "#434c53";
          bar.menus.menu.dashboard.shortcuts.recording = "#8fbcbb";
          bar.menus.menu.dashboard.shortcuts.text = "#2e3440";
          bar.menus.menu.dashboard.shortcuts.background = "#88c0d0";
          bar.menus.menu.dashboard.powermenu.confirmation.button_text = "#2e3440";
          bar.menus.menu.dashboard.powermenu.confirmation.deny = "#8fbcbb";
          bar.menus.menu.dashboard.powermenu.confirmation.confirm = "#8fbcbb";
          bar.menus.menu.dashboard.powermenu.confirmation.body = "#d8dee9";
          bar.menus.menu.dashboard.powermenu.confirmation.label = "#88c0d0";
          bar.menus.menu.dashboard.powermenu.confirmation.border = "#434c53";
          bar.menus.menu.dashboard.powermenu.confirmation.background = "#2e3440";
          bar.menus.menu.dashboard.powermenu.confirmation.card = "#3b4252";
          bar.menus.menu.dashboard.powermenu.sleep = "#88c0d0";
          bar.menus.menu.dashboard.powermenu.logout = "#8fbcbb";
          bar.menus.menu.dashboard.powermenu.restart = "#81a1c1";
          bar.menus.menu.dashboard.powermenu.shutdown = "#8fbcbb";
          bar.menus.menu.dashboard.profile.name = "#8fbcbb";
          bar.menus.menu.dashboard.border.color = "#434c53";
          bar.menus.menu.dashboard.background.color = "#2e3440";
          bar.menus.menu.dashboard.card.color = "#3b4252";
          bar.menus.menu.clock.weather.hourly.temperature = "#8fbcbb";
          bar.menus.menu.clock.weather.hourly.icon = "#8fbcbb";
          bar.menus.menu.clock.weather.hourly.time = "#8fbcbb";
          bar.menus.menu.clock.weather.thermometer.extremelycold = "#88c0d0";
          bar.menus.menu.clock.weather.thermometer.cold = "#88c0d0";
          bar.menus.menu.clock.weather.thermometer.moderate = "#88c0d0";
          bar.menus.menu.clock.weather.thermometer.hot = "#81a1c1";
          bar.menus.menu.clock.weather.thermometer.extremelyhot = "#8fbcbb";
          bar.menus.menu.clock.weather.stats = "#8fbcbb";
          bar.menus.menu.clock.weather.status = "#8fbcbb";
          bar.menus.menu.clock.weather.temperature = "#d8dee9";
          bar.menus.menu.clock.weather.icon = "#8fbcbb";
          bar.menus.menu.clock.calendar.contextdays = "#434c53";
          bar.menus.menu.clock.calendar.days = "#d8dee9";
          bar.menus.menu.clock.calendar.currentday = "#8fbcbb";
          bar.menus.menu.clock.calendar.paginator = "#8fbcbb";
          bar.menus.menu.clock.calendar.weekdays = "#8fbcbb";
          bar.menus.menu.clock.calendar.yearmonth = "#8fbcbb";
          bar.menus.menu.clock.time.timeperiod = "#8fbcbb";
          bar.menus.menu.clock.time.time = "#8fbcbb";
          bar.menus.menu.clock.text = "#d8dee9";
          bar.menus.menu.clock.border.color = "#434c53";
          bar.menus.menu.clock.background.color = "#2e3440";
          bar.menus.menu.clock.card.color = "#3b4252";
          bar.menus.menu.battery.slider.puck = "#4c566a";
          bar.menus.menu.battery.slider.backgroundhover = "#434c53";
          bar.menus.menu.battery.slider.background = "#434c53";
          bar.menus.menu.battery.slider.primary = "#81a1c1";
          bar.menus.menu.battery.icons.active = "#81a1c1";
          bar.menus.menu.battery.icons.passive = "#5e81ac";
          bar.menus.menu.battery.listitems.active = "#81a1c1";
          bar.menus.menu.battery.listitems.passive = "#d8dee9";
          bar.menus.menu.battery.text = "#d8dee9";
          bar.menus.menu.battery.label.color = "#81a1c1";
          bar.menus.menu.battery.border.color = "#434c53";
          bar.menus.menu.battery.background.color = "#2e3440";
          bar.menus.menu.battery.card.color = "#3b4252";
          bar.menus.menu.systray.dropdownmenu.divider = "#3b4252";
          bar.menus.menu.systray.dropdownmenu.text = "#d8dee9";
          bar.menus.menu.systray.dropdownmenu.background = "#2e3440";
          bar.menus.menu.bluetooth.iconbutton.active = "#88c0d0";
          bar.menus.menu.bluetooth.iconbutton.passive = "#d8dee9";
          bar.menus.menu.bluetooth.icons.active = "#88c0d0";
          bar.menus.menu.bluetooth.icons.passive = "#5e81ac";
          bar.menus.menu.bluetooth.listitems.active = "#88c0d0";
          bar.menus.menu.bluetooth.listitems.passive = "#d8dee9";
          bar.menus.menu.bluetooth.switch.puck = "#434c53";
          bar.menus.menu.bluetooth.switch.disabled = "#434c53";
          bar.menus.menu.bluetooth.switch.enabled = "#88c0d0";
          bar.menus.menu.bluetooth.switch_divider = "#434c53";
          bar.menus.menu.bluetooth.status = "#4c566a";
          bar.menus.menu.bluetooth.text = "#d8dee9";
          bar.menus.menu.bluetooth.label.color = "#88c0d0";
          bar.menus.menu.bluetooth.border.color = "#434c53";
          bar.menus.menu.bluetooth.background.color = "#2e3440";
          bar.menus.menu.bluetooth.card.color = "#3b4252";
          bar.menus.menu.network.iconbuttons.active = "#88c0d0";
          bar.menus.menu.network.iconbuttons.passive = "#d8dee9";
          bar.menus.menu.network.icons.active = "#88c0d0";
          bar.menus.menu.network.icons.passive = "#5e81ac";
          bar.menus.menu.network.listitems.active = "#88c0d0";
          bar.menus.menu.network.listitems.passive = "#d8dee9";
          bar.menus.menu.network.status.color = "#4c566a";
          bar.menus.menu.network.text = "#d8dee9";
          bar.menus.menu.network.label.color = "#88c0d0";
          bar.menus.menu.network.border.color = "#434c53";
          bar.menus.menu.network.background.color = "#2e3440";
          bar.menus.menu.network.card.color = "#3b4252";
          bar.menus.menu.volume.input_slider.puck = "#434c53";
          bar.menus.menu.volume.input_slider.backgroundhover = "#434c53";
          bar.menus.menu.volume.input_slider.background = "#434c53";
          bar.menus.menu.volume.input_slider.primary = "#81a1c1";
          bar.menus.menu.volume.audio_slider.puck = "#434c53";
          bar.menus.menu.volume.audio_slider.backgroundhover = "#434c53";
          bar.menus.menu.volume.audio_slider.background = "#434c53";
          bar.menus.menu.volume.audio_slider.primary = "#81a1c1";
          bar.menus.menu.volume.icons.active = "#81a1c1";
          bar.menus.menu.volume.icons.passive = "#5e81ac";
          bar.menus.menu.volume.iconbutton.active = "#81a1c1";
          bar.menus.menu.volume.iconbutton.passive = "#d8dee9";
          bar.menus.menu.volume.listitems.active = "#81a1c1";
          bar.menus.menu.volume.listitems.passive = "#d8dee9";
          bar.menus.menu.volume.text = "#d8dee9";
          bar.menus.menu.volume.label.color = "#81a1c1";
          bar.menus.menu.volume.border.color = "#434c53";
          bar.menus.menu.volume.background.color = "#2e3440";
          bar.menus.menu.volume.card.color = "#3b4252";
          bar.menus.menu.media.slider.puck = "#4c566a";
          bar.menus.menu.media.slider.backgroundhover = "#434c53";
          bar.menus.menu.media.slider.background = "#434c53";
          bar.menus.menu.media.slider.primary = "#8fbcbb";
          bar.menus.menu.media.buttons.text = "#2e3440";
          bar.menus.menu.media.buttons.background = "#88c0d0";
          bar.menus.menu.media.buttons.enabled = "#8fbcbb";
          bar.menus.menu.media.buttons.inactive = "#434c53";
          bar.menus.menu.media.border.color = "#434c53";
          bar.menus.menu.media.card.color = "#3b4252";
          bar.menus.menu.media.background.color = "#2e3440";
          bar.menus.menu.media.album = "#8fbcbb";
          bar.menus.menu.media.artist = "#8fbcbb";
          bar.menus.menu.media.song = "#88c0d0";
          bar.menus.tooltip.text = "#d8dee9";
          bar.menus.tooltip.background = "#2e3440";
          bar.menus.dropdownmenu.divider = "#3b4252";
          bar.menus.dropdownmenu.text = "#d8dee9";
          bar.menus.dropdownmenu.background = "#2e3440";
          bar.menus.slider.puck = "#4c566a";
          bar.menus.slider.backgroundhover = "#434c53";
          bar.menus.slider.background = "#434c53";
          bar.menus.slider.primary = "#88c0d0";
          bar.menus.progressbar.background = "#434c53";
          bar.menus.progressbar.foreground = "#88c0d0";
          bar.menus.iconbuttons.active = "#88c0d0";
          bar.menus.iconbuttons.passive = "#d8dee9";
          bar.menus.buttons.text = "#2e3440";
          bar.menus.buttons.disabled = "#434c53";
          bar.menus.buttons.active = "#8fbcbb";
          bar.menus.buttons.default = "#88c0d0";
          bar.menus.check_radio_button.active = "#88c0d0";
          bar.menus.check_radio_button.background = "#2e3440";
          bar.menus.switch.puck = "#434c53";
          bar.menus.switch.disabled = "#434c53";
          bar.menus.switch.enabled = "#88c0d0";
          bar.menus.icons.active = "#88c0d0";
          bar.menus.icons.passive = "#434c53";
          bar.menus.listitems.active = "#88c0d0";
          bar.menus.listitems.passive = "#d8dee9";
          bar.menus.popover.border = "#2e3440";
          bar.menus.popover.background = "#2e3440";
          bar.menus.popover.text = "#88c0d0";
          bar.menus.label = "#88c0d0";
          bar.menus.feinttext = "#434c53";
          bar.menus.dimtext = "#6272a4";
          bar.menus.text = "#d8dee9";
          bar.menus.border.color = "#434c53";
          bar.menus.cards = "#3b4252";
          bar.menus.background = "#2e3440";
          bar.buttons.modules.power.icon_background = "#8fbcbb";
          bar.buttons.modules.power.icon = "#8fbcbb";
          bar.buttons.modules.power.background = "#3b4252";
          bar.buttons.modules.weather.icon_background = "#88c0d0";
          bar.buttons.modules.weather.icon = "#88c0d0";
          bar.buttons.modules.weather.text = "#88c0d0";
          bar.buttons.modules.weather.background = "#3b4252";
          bar.buttons.modules.updates.icon_background = "#88c0d0";
          bar.buttons.modules.updates.icon = "#88c0d0";
          bar.buttons.modules.updates.text = "#88c0d0";
          bar.buttons.modules.updates.background = "#3b4252";
          bar.buttons.modules.kbLayout.icon_background = "#88c0d0";
          bar.buttons.modules.kbLayout.icon = "#88c0d0";
          bar.buttons.modules.kbLayout.text = "#88c0d0";
          bar.buttons.modules.kbLayout.background = "#3b4252";
          bar.buttons.modules.netstat.icon_background = "#8fbcbb";
          bar.buttons.modules.netstat.icon = "#8fbcbb";
          bar.buttons.modules.netstat.text = "#8fbcbb";
          bar.buttons.modules.netstat.background = "#3b4252";
          bar.buttons.modules.storage.icon_background = "#8fbcbb";
          bar.buttons.modules.storage.icon = "#8fbcbb";
          bar.buttons.modules.storage.text = "#8fbcbb";
          bar.buttons.modules.storage.background = "#3b4252";
          bar.buttons.modules.cpu.icon_background = "#8fbcbb";
          bar.buttons.modules.cpu.icon = "#8fbcbb";
          bar.buttons.modules.cpu.text = "#8fbcbb";
          bar.buttons.modules.cpu.background = "#3b4252";
          bar.buttons.modules.ram.icon_background = "#81a1c1";
          bar.buttons.modules.ram.icon = "#81a1c1";
          bar.buttons.modules.ram.text = "#81a1c1";
          bar.buttons.modules.ram.background = "#3b4252";
          bar.buttons.notifications.total = "#88c0d0";
          bar.buttons.notifications.icon_background = "#88c0d0";
          bar.buttons.notifications.icon = "#88c0d0";
          bar.buttons.notifications.background = "#3b4252";
          bar.buttons.clock.icon_background = "#8fbcbb";
          bar.buttons.clock.icon = "#8fbcbb";
          bar.buttons.clock.text = "#8fbcbb";
          bar.buttons.clock.background = "#3b4252";
          bar.buttons.battery.icon_background = "#81a1c1";
          bar.buttons.battery.icon = "#81a1c1";
          bar.buttons.battery.text = "#81a1c1";
          bar.buttons.battery.background = "#3b4252";
          bar.buttons.systray.background = "#3b4252";
          bar.buttons.bluetooth.icon_background = "#89dbeb";
          bar.buttons.bluetooth.icon = "#88c0d0";
          bar.buttons.bluetooth.text = "#88c0d0";
          bar.buttons.bluetooth.background = "#3b4252";
          bar.buttons.network.icon_background = "#caa6f7";
          bar.buttons.network.icon = "#88c0d0";
          bar.buttons.network.text = "#88c0d0";
          bar.buttons.network.background = "#3b4252";
          bar.buttons.volume.icon_background = "#81a1c1";
          bar.buttons.volume.icon = "#81a1c1";
          bar.buttons.volume.text = "#81a1c1";
          bar.buttons.volume.background = "#3b4252";
          bar.buttons.media.icon_background = "#88c0d0";
          bar.buttons.media.icon = "#88c0d0";
          bar.buttons.media.text = "#88c0d0";
          bar.buttons.media.background = "#3b4252";
          bar.buttons.windowtitle.icon_background = "#8fbcbb";
          bar.buttons.windowtitle.icon = "#8fbcbb";
          bar.buttons.windowtitle.text = "#8fbcbb";
          bar.buttons.windowtitle.background = "#3b4252";
          bar.buttons.workspaces.numbered_active_underline_color = "#ffffff";
          bar.buttons.workspaces.numbered_active_highlighted_text_color = "#21252b";
          bar.buttons.workspaces.active = "#8fbcbb";
          bar.buttons.workspaces.occupied = "#81a1c1";
          bar.buttons.workspaces.available = "#88c0d0";
          bar.buttons.workspaces.hover = "#434c53";
          bar.buttons.workspaces.background = "#3b4252";
          bar.buttons.dashboard.icon = "#81a1c1";
          bar.buttons.dashboard.background = "#3b4252";
          bar.buttons.icon = "#88c0d0";
          bar.buttons.text = "#88c0d0";
          bar.buttons.hover = "#434c53";
          bar.buttons.icon_background = "#3b4252";
          bar.buttons.background = "#3b4252";
          bar.buttons.style = "default";
          bar.background = "#2e3440";
          osd.label = "#88c0d0";
          osd.icon = "#2e3440";
          osd.bar_overflow_color = "#8fbcbb";
          osd.bar_empty_color = "#434c53";
          osd.bar_color = "#88c0d0";
          osd.icon_container = "#88c0d0";
          osd.bar_container = "#2e3440";
          notification.close_button.label = "#2e3440";
          notification.close_button.background = "#8fbcbb";
          notification.labelicon = "#88c0d0";
          notification.text = "#d8dee9";
          notification.time = "#4c566a";
          notification.border = "#434c53";
          notification.label = "#88c0d0";
          notification.actions.text = "#2e3440";
          notification.actions.background = "#88c0d0";
          notification.background = "#2e3440";
          bar.buttons.modules.power.border = "#8fbcbb";
          bar.buttons.modules.weather.border = "#88c0d0";
          bar.buttons.modules.updates.border = "#88c0d0";
          bar.buttons.modules.kbLayout.border = "#88c0d0";
          bar.buttons.modules.netstat.border = "#8fbcbb";
          bar.buttons.modules.storage.border = "#8fbcbb";
          bar.buttons.modules.cpu.border = "#8fbcbb";
          bar.buttons.modules.ram.border = "#81a1c1";
          bar.buttons.notifications.border = "#88c0d0";
          bar.buttons.clock.border = "#8fbcbb";
          bar.buttons.battery.border = "#81a1c1";
          bar.buttons.systray.border = "#434c53";
          bar.buttons.bluetooth.border = "#88c0d0";
          bar.buttons.network.border = "#88c0d0";
          bar.buttons.volume.border = "#81a1c1";
          bar.buttons.media.border = "#88c0d0";
          bar.buttons.windowtitle.border = "#8fbcbb";
          bar.buttons.workspaces.border = "#2e3440";
          bar.buttons.dashboard.border = "#81a1c1";
          bar.buttons.modules.submap.background = "#3b4252";
          bar.buttons.modules.submap.text = "#8fbcbb";
          bar.buttons.modules.submap.border = "#8fbcbb";
          bar.buttons.modules.submap.icon = "#8fbcbb";
          bar.buttons.modules.submap.icon_background = "#3b4252";
          bar.menus.menu.network.switch.enabled = "#88c0d0";
          bar.menus.menu.network.switch.disabled = "#434c53";
          bar.menus.menu.network.switch.puck = "#434c53";
          bar.buttons.systray.customIcon = "#d8dee9";
          bar.border.color = "#88c0d0";
          bar.menus.menu.media.timestamp = "#d8dee9";
          bar.buttons.borderColor = "#88c0d0";
          bar.buttons.modules.hyprsunset.icon = "#81a1c1";
          bar.buttons.modules.hyprsunset.background = "#3b4252";
          bar.buttons.modules.hyprsunset.icon_background = "#81a1c1";
          bar.buttons.modules.hyprsunset.text = "#81a1c1";
          bar.buttons.modules.hyprsunset.border = "#81a1c1";
          bar.buttons.modules.hypridle.icon = "#8fbcbb";
          bar.buttons.modules.hypridle.background = "#3b4252";
          bar.buttons.modules.hypridle.icon_background = "#8fbcbb";
          bar.buttons.modules.hypridle.text = "#8fbcbb";
          bar.buttons.modules.hypridle.border = "#8fbcbb";
          bar.menus.menu.network.scroller.color = "#88c0d0";
          bar.menus.menu.bluetooth.scroller.color = "#88c0d0";
          bar.buttons.modules.cava.text = "#8fbcbb";
          bar.buttons.modules.cava.background = "#3b4252";
          bar.buttons.modules.cava.icon_background = "#3b4252";
          bar.buttons.modules.cava.icon = "#8fbcbb";
          bar.buttons.modules.cava.border = "#8fbcbb";
          bar.buttons.modules.microphone.border = "#8fbcbb";
          bar.buttons.modules.microphone.background = "#3b4252";
          bar.buttons.modules.microphone.text = "#8fbcbb";
          bar.buttons.modules.microphone.icon = "#8fbcbb";
          bar.buttons.modules.microphone.icon_background = "#3b4252";
          bar.buttons.modules.worldclock.text = "#8fbcbb";
          bar.buttons.modules.worldclock.background = "#3b4252";
          bar.buttons.modules.worldclock.icon_background = "#8fbcbb";
          bar.buttons.modules.worldclock.icon = "#8fbcbb";
          bar.buttons.modules.worldclock.border = "#8fbcbb";
          bar.buttons.notifications.hover = "#504945";
          bar.buttons.clock.hover = "#504945";
          bar.buttons.battery.hover = "#504945";
          bar.buttons.systray.hover = "#504945";
          bar.buttons.bluetooth.hover = "#504945";
          bar.buttons.network.hover = "#504945";
          bar.buttons.volume.hover = "#504945";
          bar.buttons.media.hover = "#504945";
          bar.buttons.windowtitle.hover = "#504945";
          bar.buttons.workspaces.numbered_active_text_color = "#24283b";
          bar.buttons.dashboard.hover = "#504945";
          bar.menus.menu.power.card.color = "#2a283e";
          bar.buttons.modules.cpu.hover = "#45475a";
          bar.buttons.volume.output_icon = "#11111b";
          bar.buttons.volume.output_text = "#eba0ac";
          bar.buttons.volume.input_icon = "#11111b";
          bar.buttons.volume.input_text = "#eba0ac";
          bar.buttons.volume.separator = "#45475a";
          bar.buttons.modules.cpuTemp.icon_background = "#fab387";
          bar.buttons.modules.cpuTemp.icon = "#fab387";
          bar.buttons.modules.cpuTemp.text = "#fab387";
          bar.buttons.modules.cpuTemp.border = "#fab387";
          osd.border.color = "#8ff0a4";
        };
      };
    };

    hyprlock = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    lutris.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;

          keymaps = [
            {
              key = "<C-/>";
              mode = "t";
              silent = true;
              action = "<cmd>ToggleTerm<CR>";
            }
          ];

          options = {
            expandtab = true;
            shiftwidth = 2;
            tabstop = 2;
          };

          statusline.lualine.enable = true;

          autocomplete.nvim-cmp = {
            enable = true;
            mappings = {
              close = "<Esc>";
              complete = "<C-Space>";
              confirm = "<CR>";
              next = "<C-n>";
              previous = "<C-p>";
            };
          };

          debugger.nvim-dap = {
            enable = true;
            ui.enable = true;
          };

          theme = {
            enable = true;
            name = "nord";
            style = "night";
          };

          terminal.toggleterm = {
            enable = true;
            mappings.open = "<C-/>";
            setupOpts.direction = "float";
          };

          languages = {
            enableFormat = true;
            enableTreesitter = true;

            bash.enable = true;
            csharp.enable = true;
            lua.enable = true;
            nix = {
              enable = true;
              treesitter.enable = true;
            };

            rust = {
              enable = true;
              crates.enable = true;
              dap.enable = true;
              lsp.opts = ''
                ['rust-analyzer'] = {
                  cargo = {allFeature = true},
                  checkOnSave = true,
                  procMacro = {
                    enable = true,
                  },
                },
              '';
            };
          };

          lsp = {
            enable = true;
            formatOnSave = true;
            inlayHints.enable = true;
            lspkind.enable = true;
            lspSignature.enable = true;
            mappings = {
              codeAction = "<leader>a";
              goToDeclaration = "gd";
              goToDefinition = "gD";
              hover = "K";
            };
          };

          binds.whichKey = {
            enable = true;
          };

          comments.comment-nvim.enable = true;

          telescope = {
            enable = true;
            mappings = {
              diagnostics = "<leader>sd";
              findFiles = "<leader><leader>";
              liveGrep = "<leader>sg";
              lspDefinitions = "<leader>sd";
              lspDocumentSymbols = "<leader>ss";
              lspWorkspaceSymbols = "<leader>sw";
              lspReferences = "<leader>sr";
              lspImplementations = "<leader>si";
            };
            extensions = [
              {
                name = "fzf";
                packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
                setup = {fzf = {fuzzy = true;};};
              }
            ];
          };

          visuals = {
            fidget-nvim.enable = true;

            nvim-web-devicons.enable = true;
          };

          filetree.nvimTree = {
            enable = true;
            openOnSetup = false;
            setupOpts = {
              view.float = {
                enable = true;
                quit_on_focus_loss = true;
              };
            };
          };

          ui = {
            noice.enable = true;
          };

          mini.pairs = {
            enable = true;

            setupOpts = {
              mappings = {"'" = false;};
            };
          };
        };
      };
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
      };
    };
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock";
        };

        listener = [
          {
            timeout = 120;
            on-timeout = "hyprlock";
          }
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
