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
  kpackage = pkgs.linuxKernel.packages.linux_xanmod_stable;
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
    kernelPackages = kpackage;

    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "vhci-hcd"
      ];
      kernelModules = [ "amdgpu" "tun" ];
      systemd.enable = true;
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = with config.boot.kernelPackages; [
      usbip
      v4l2loopback
      iio-utils
      fanout
      evdi
      cpupower
      # shufflecake
      ((pkgs.plusultra.amdgpu-kernel-module.override{ kernel = kpackage.kernel; }).overrideAttrs (_: {
        # kernel = kpackage.kernel;
        patches = [
          (pkgs.fetchpatch {
            name = "cap_sys_nice_begone.patch";
            url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
            hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
          })
        ];
      }))
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
  systemd.network.enable = false;

  hardware.enableRedistributableFirmware = true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;
}
