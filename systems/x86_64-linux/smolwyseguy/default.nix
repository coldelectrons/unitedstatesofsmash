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

  boot = {
    binfmt.emulatedSystems = [  ];
    consoleLogLevel = 0;
    kernelParams = [ ];                                                                                                                                   
  };

  environment.systemPackages = with pkgs; [
    # pciutils
    usbutils
    htop
    bottom
  ];

  hardware.bluetooth = disabled;
  hardware.enableAllFirmware = true;

  plusultra = {
    nix = enabled;
    archetypes = {
      server = enabled;
    };
    cli-apps = {
    };
    security = {
      gpg = enabled;
    };
    apps = {
    };
    hardware = {
    };
    services = {
      mdns-publisher = enabled // {
        names = [
          "smolwyseguy.local"
        ];
      };
    };

    system = {
      # iot-network = enabled // {
      #   interface = "enp4s0";
      # };
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

