{ pkgs
, config
, lib
, channel
, namespace
, ...
}:
with lib;
with lib.${namespace};
{
  imports = [ ./hardware.nix ];

  # Resolve an issue with stickers's wired connections failing sometimes due to weird
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
    plymouth.enable = true;
    # Swapfile hibernate
    # resumeDevice = "${MAIN_PART}";
    # kernelParams = [ "resume_offset=${RESUME_OFFSET}" "nvidia_drm.fbdev=1" ];
  };

  environment.systemPackages = with pkgs; [
    # vivaldi
    plusultra.neovim
    neovide
  ];

  nix.settings.trusted-users = [ "root" "coldelectrons"];

  plusultra = {
    user.extraGroups = [ 
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
    
    nix = enabled;

    suites = {
      common = enabled;
      desktop = enabled;
      media = enabled;
      ereader = enabled;
    };

    cli-apps = {
      extras = enabled;
      # gurk-rs = enabled;
      downloaders = enabled;
      markdown = enabled;
    };

    security = {
      acme = enabled;
      gpg = enabled;
    };

    apps = {
      vivaldi = enabled;
      syncthing = enabled;
    };

    hardware = {
      graphics = enabled;
      networking = enabled;
    };

    services = {
      # printing = enabled;
      tailscale = enabled;
    };

    archetypes = {
      # gaming = enabled;
      # workstation = enabled;
      # laptop = enabled;
    };

    desktop = {
      plasma6 = enabled;  
    };

    tools = {
    };

    system = {
      fonts = enabled // {
        fonts = with pkgs.nerd-fonts; [
          fira-code
          fira-mono
          meslo-lg
          hack
          symbols-only
        ];
      };
    };
  };
  
  # hardware.nvidia.open = true;
  # hardware.nvidia.prime = {
  #   offload.enable = true;
  #   intelBusId = "PCI:0:2:0";
  #   nvidiaBusId = "PCI:1:0:0";
  # };

  # WiFi is typically unused on the desktop. Enable this service
  # if it's no longer only using a wired connection.
  systemd.services.network-addresses-wlp41s0.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
