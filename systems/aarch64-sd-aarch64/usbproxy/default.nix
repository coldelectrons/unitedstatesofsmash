{
  pkgs,
  config,
  lib,
  modulesPath,
  inputs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
{
  imports = with inputs.nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    raspberry-pi-3
  ];

  nix.package = lib.mkForce pkgs.nix; 

  nixpkgs.config.allowUnsupportedSystem = true;

  nixpkgs.crossSystem.system = "aarch64-linux";
  nixpkgs.buildPlatform = "x86_64-linux";
  nixpkgs.hostPlatform = "aarch64-linux";

  # TODO move this to a nixos module just for arm stuff
  nix.buildMachines = [
    {
      hostName = "pi4builder";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures, 
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
  };

  plusultra = {
    system = {
      boot = {
        # Raspberry Pi requires a specific bootloader.
        enable = mkForce false;
      };
    };

    archetypes = {
      server = enabled;
    };

    services = {
      usbipd = enabled // {
        devices = [
          { # sigma micro keyboard
            productid = "1c4f";
            vendorid  = "0027";
          }
          { # omtech galvo laser BJJCZ USBLMCV4
            productid = "9588";
            vendorid  = "9899";
          }
          { # grblhal teeny4
            productid = "16c0";
            vendorid  = "0483";
          }
          { # Brother Industries, Ltd ADS-4700W
            productid = "04f9";
            vendorid  = "04d5";
          }
          { # HP Laserjet 1102w
            productid = "03f0";
            vendorid  = "102a";
          }
        ];
      };
    };

  };

  environment.systemPackages = with pkgs; [
  ];

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
