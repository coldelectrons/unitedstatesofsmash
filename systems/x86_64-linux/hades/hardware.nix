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
    common-cpu-amd
    common-gpu-amd
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
      kernelModules = [ "amdgpu" "tun" ];
      systemd.enable = true;
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = with config.boot.kernelPackages; [
      zenpower
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/home/coldelectrons" = {
    device = "/dev/disk/by-label/coldelectrons";
    fsType = "ext4";
  };

  fileSystems."/home/coldelectrons/.local/share/Steam" = {
    device = "/dev/disk/by-label/Steam";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  # NOTE: NetworkManager will handle DHCP.
  networking.interfaces.enp39s0.useDHCP = false;
  networking.interfaces.wlp41s0.useDHCP = false;

  hardware.enableRedistributableFirmware = true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;
}
