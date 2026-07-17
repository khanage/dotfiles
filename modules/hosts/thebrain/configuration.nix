{self, ...}: {
  flake.nixosModules.thebrainConfiguration = {
    pkgs,
    config,
    ...
  }: {
    _module.args.k8sconfig = {
      server_addr = "192.168.1.43";
    };
    imports = [
      self.nixosModules.thebrainSops
      self.nixosModules.thebrainHardware
      self.nixosModules.k8s_primary
    ];

    boot.kernel.sysctl."kernel.dmesg_restrict" = 0;

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      settings = {
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
        trusted-users = ["root" "khan"];
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking = {
      hostName = "thebrain"; # Easiest to use and most distros use this by default.
      enableIPv6 = false;
      networkmanager = {
        enable = true;
        ensureProfiles = {
          environmentFiles = [config.sops.templates."wifi-env".path];
          profiles.QONOS = {
            connection = {
              id = "QONOS";
              type = "wifi";
            };
            wifi = {
              ssid = "QONOS";
              mode = "infrastructure";
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$wifi_password";
            };
          };
        };
      };
    };

    time.timeZone = "Australia/Melbourne";
    i18n.defaultLocale = "en_AU.UTF-8";

    console.font = "Lat2-Terminus16";

    users.users.khan = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      packages = with pkgs; [tree];
    };

    environment.variables = {
      TERM = "xterm";
    };

    environment.systemPackages = with pkgs; [vim git wget];

    services.openssh = {
      enable = true;
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 22;
        }
      ];
    };

    networking.firewall.enable = false;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
