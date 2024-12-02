{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
let
  inherit (inputs) nixos-hardware;
in
{
  imports = with nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    common-cpu-intel
    common-gpu-nvidia
    common-pc
    common-pc-ssd
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "noveau" "tun" ];
      systemd.enable = true;
    };
    # kernelModules = [ "kvm-amd" ];
    extraModulePackages = with config.boot.kernelPackages; [
      zenpower
    ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b168bb9d-4769-467e-9618-126769a5bbdc";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F412-1BDD";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  networking.useDHCP = lib.mkDefault true;
  # NOTE: NetworkManager will handle DHCP.
  networking.interfaces.enp39s0.useDHCP = false;
  networking.interfaces.wlp41s0.useDHCP = false;

  hardware.enableRedistributableFirmware = true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;
}
