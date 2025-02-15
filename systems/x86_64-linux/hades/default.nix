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
    binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];
    consoleLogLevel = 0;
    kernelParams = [ 
    ];                                                                                                                                   
    # plymouth.enable = true;
    # Swapfile hibernate
    # resumeDevice = "${MAIN_PART}";
    # kernelParams = [ "resume_offset=${RESUME_OFFSET}" "nvidia_drm.fbdev=1" ];
  };

  environment.systemPackages = with pkgs; [
    plusultra.balor

    media-downloader
    yt-dlg
    pipe-viewer
    gtk-pipe-viewer
    kdePackages.plasmatube
    tartube-yt-dlp
    invidious

    nur.repos.dukzcry.stable-diffusion-cpp
    nur.repos.dukzcry.sd-cpp-webui

    oterm
    alpaca

    super-slicer-beta

  ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    acceleration = "rocm";
  };

  plusultra = {
    nix = enabled;
    archetypes = {
      gaming = enabled;
      workstation = enabled;
    };
    desktop = {
      plasma6 = enabled // {
        wayland = true;
        extensions = with pkgs; [
          kdePackages.krohnkite
        ];
      };
    };
    cli-apps = {
      extras = enabled;
      downloaders = enabled;
      messenging = enabled;
      markdown = enabled;
    };
    security = {
      acme = enabled;
      gpg = enabled;
      sops = enabled;
    };
    apps = {
      vivaldi = enabled;
      syncthing = enabled;
      steam = enabled;
      # comfyui = enabled;
      steamtinkerlaunch = enabled;
      r2modman = enabled;
      # simula = enabled;
      # rpcs3 = enabled;
      # ubports-installer = enabled;
    };
    hardware = {
      vr = enabled // {
      #   monadoDefaultEnable = false;
      };
      nofio-wireless = enabled;
      spacenav = enabled;
      graphics = enabled // {
        amdgpu = enabled;
      };
    };
    services = {
      esphome = enabled;
      # usbip = enabled // {
      #   devices = [
      #     { # omtech galvo laser
      #       host = "usbproxy1.localdomain";
      #       device = "9588:9899";
      #     }
      #     { # grblhal teensy4
      #       host = "usbproxy1.local";
      #       device = "16c0:0483";
      #     }
      #   ];
      # };
    };
    virtualisation.kvm = {
      enable = true;
      platform = "amd";
    #   # TODO I'm not currently using passthrough
    #   # IOMMU Group 23 23:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] [1002:67df] (rev c7)
    #   # IOMMU Group 23 23:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1002:aaf0]
    #   vfioIds = [
    #     "1002:67df"
    #     "1002:aaf0"
    #   ];
    #   machineUnits = [ "machine-qemu\\x2d1\\x2dwin10.scope" ];
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
      "gamemode"
    ];
  };

  services.udev.packages = with pkgs; [ plusultra.laser-usb-udev-rules ];

  services.snap.enable = true;
  
    # Force radv
  environment.variables = {
    # Don't use this per https://gitlab.com/vr-on-linux/VR-on-Linux/-/issues/23#note_1472796145
    # AMD_VULKAN_ICD = "RADV";
    DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1="1";
    VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json";
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
