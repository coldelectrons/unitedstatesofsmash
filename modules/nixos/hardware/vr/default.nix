{
  options,
  config,
  pkgs,
  lib,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.vr;
  user = config.${namespace}.user;
  home = config.users.users.${user.name}.home;
  desktopItem = pkgs.makeDesktopItem {
    name = "wlx-overlay";
    desktopName = "WLX Overlay";
    genericName = "WLX Overlay for SteamVR";
    exec = "${pkgs.wlx-overlay-s}/bin/wlx-overlay-s --replace";
    icon = ./wlx-overlay-s.png;
    type = "Application";
    categories = [ "Game" "VR" ];
    terminal = false;
  };
in
{
  options.${namespace}.hardware.vr = with types; {
    enable = mkBoolOpt false "Whether or not to enable VR/XR support.";
    monadoDefaultEnable = mkBoolOpt false "Whether or not to enable Monado as the default XR runtime.";
  };

  config = mkIf cfg.enable {

    # Fixes issue with SteamVR not starting
    system.activationScripts = {
      fixSteamVR =
        "${pkgs.libcap}/bin/setcap CAP_SYS_NICE+ep ${home}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
    };

    services.udev.packages = with pkgs; [
      xr-hardware
      plusultra.nofio-usb-udev-rules
    ];

    services.monado = {
      enable = true;
      defaultRuntime = cfg.monadoDefaultEnable;
      highPriority = true;
    };

    systemd.user.services.monado = {
      serviceConfig = {
        ExecStartPost = "${lib.getExe pkgs.lighthouse-steamvr} -s ON";
         ExecStopPost = "${lib.getExe pkgs.lighthouse-steamvr} -s OFF";
      };
      environment = {
        STEAMVR_PATH = "${home}/.steam/root/steamapps/common/SteamVR";
        STEAM_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
        XRT_COMPOSITOR_SCALE_PERCENTAGE = "140";
        WMR_HANDTRACKING = "1";
      };
    };

    environment.sessionVariables = {
      # why is this necessary?
      LIBMONADO_PATH = "${config.services.monado.package}/lib/libmonado.so";
    };

    programs.steam = {
      # extraCompatPackages = [
      #   # FIXME this causes 
      #   # The store path /nix/store/l7wmmarasbmxiz4xciv6bch0zwqmvvm4-proton-ge-rtsp-bin-GE-Proton9-20-rtsp16 is a file and can't be merged into an environment using pkgs.buildEnv!
      #   # so manually install it for now
      #   inputs.nixpkgs-xr.packages.${pkgs.system}.proton-ge-rtsp-bin # for resonite??
      # ];
      extraPackages = with pkgs; [
        # FIXME had a problem with steam and bluetooth, dunno if these helped
        hidapi
        monado-vulkan-layers # this
      ];
    };

    hardware.graphics.extraPackages = with pkgs; [
      monado-vulkan-layers
      mangohud
      gamemode
    ];

    environment.systemPackages = with pkgs; [
      # todo move nofio to it's own module
      plusultra.virtualhere # for the nofio wireless adapter
      lighthouse-steamvr
      monado-vulkan-layers
      wlx-overlay-s
      opencomposite
      libsurvive
      # motoc
      basalt-monado
      xrgears
      # xr-hardware

      stardust-xr-atmosphere
      stardust-xr-sphereland
      stardust-xr-protostar
      stardust-xr-flatland
      stardust-xr-magnetar
      stardust-xr-phobetor
      stardust-xr-gravity
      stardust-xr-server
      stardust-xr-kiara
    ];

    boot.kernelPatches = [
      {
        name = "amdgpu-ignore-ctx-privileges";
        patch = pkgs.fetchpatch {
          name = "cap_sys_nice_begone.patch";
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        };
      }
    ];
  };
}
