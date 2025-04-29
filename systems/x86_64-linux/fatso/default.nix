{ pkgs
, config
, lib
, channel
, namespace
, inputs
, ...
}:
with lib;
with lib.${namespace};
{
  imports = [ ./hardware.nix ];

  # Resolve an issue with hades's wired connections failing sometimes due to weird
  # DHCP issues. I'm not quite sure why this is the case, but I have found that the
  # problem can be resolved by stopping dhcpcd, restarting Network Manager, and then
  # unplugging and replugging the ethernet cable. Perhaps there's some weird race
  # condition when the system is coming up that causes this.
  networking.dhcpcd.enable = false;


  boot = {
    binfmt.emulatedSystems = [  ];
    consoleLogLevel = 0;
    kernelParams = [ 
    ];                                                                                                                                   
  };

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    bluetui
    bluetuith
    bluez-tools
    bluewalker
    impala
    dbmonster
    ifwifi
    loramon
    home-assistant-cli
    htop
    bottom
    iw
  ];

  hardware.bluetooth = enabled;
  hardware.enableAllFirmware = true;

  # systemd.services.godns = {
  #   description = "godns";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = ''${pkgs.godns}/bin/godns --c "/etc/godns/config.json"'';
  #     Restart = "always";
  #   };
  # };
  # environment.etc."godns/config.json".text = builtins.toJSON {
  #   provider = "Dreamhost";
  #   password = "";
  #   login_token = "${lib.strings.fileContents ./token.key}";
  #   domains = [
  #     {
  #       domain_name = "www.dreamhost.com";
  #       sub_domains = [ "${lib.strings.fileContents ./domain.key}" ];
  #     }
  #   ];
  #   resolver = "8.8.8.8";
  #   # ip_urls = [ "https://api.ip.sb/ip" ];
  #   ip_type = "IPv4";
  #   interval = 300;
  #   socks5_proxy = "";
  #   skip_ssl_verify = "true";
  # };
  # networking = {
  #   hostName = "fatso";
  #   wireless = {
  #     enable = true;
  #     secretsFile = config.sops.secrets."wifi".path;
  #     networks = {
  #       "iot" = {
  #         hidden = true;
  #         # passwordFile = secrets.wifi-passwords.iot.path;
  #         psk = "ext:iot/psk";
  #       };
  #     };
  #   };
  # };

  # networking.networkmanager.unmanaged = [ "interface-name:wlp1s0" ];
  # networking.interfaces.wlp1s0 = {
  #   ipv4.addresses = [
  #     {
  #       address = "192.168.3.1";
  #       prefixLength = 24;
  #     }
  #   ];
  # };


  services.mosquitto = enabled // {
  };


  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "frithomas@gmail.com";
  #   certs."destinesia.xyz" = {
  #     domain = "*.destinesia.xyz";
  #     extraDomains = [ "fatso.destinesia.xyz" ];
  #     dnsProvider = "dreamhost";
  #     group = config.services.nginx.group;
  #     credentialsFile = config.sops.secrets.fatso-acme-apikey.path;
  #     dnsPropagationCheck = true;
  #   };
  # };


  plusultra = {
    nix = enabled;
    archetypes = {
      server = enabled;
    };
    cli-apps = {
      filemanagers = enabled;
      extras = enabled;
    };
    security = {
      acme = enabled;
      gpg = enabled;
    };
    apps = {
    };
    hardware = {
    };
    services = {
      home-assistant = enabled;
      # esphome = enabled;
      mdns-publisher = enabled // {
        names = [
          # "grafana.local"
          # "esphome.fatso.local"
          # "prometheus.local"
          # "loki.local"
          # "promtail.local"
          "home.local"
        ];
      };
    };

    system = {
      iot-network = enabled // {
        interface = "enp4s0";
      };
    };

    user.extraGroups = [ 
      "networkmanager"
      "wheel"
      "input"
      "plugdev"
      "dialout"
      "video"
      "audio"
      "libvirtd"
      "scanner"
      "i2c"
      "git"
    ];
  };

  users.users.coldelectrons = {
    extraGroups = [ "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNLc53xO8V/nzz1ebEGRplW0AeWhTUcYB1ZuWlRYDV1"
    ];
  };
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNLc53xO8V/nzz1ebEGRplW0AeWhTUcYB1ZuWlRYDV1"
    ];
  };

  # WiFi is typically unused on the desktop. Enable this service
  # if it's no longer only using a wired connection.
  # systemd.services.network-addresses-wlp41s0.enable = false;

  # something is making me wait 120 seconds, and I *hate* it
  systemd.network.wait-online.timeout = 0;
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.timeout = 0;
  boot.initrd.systemd.network.wait-online.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
