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
      fixSteamVR = "${pkgs.libcap}/bin/setcap CAP_SYS_NICE+ep ${home}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
      # fixMonadoVR = "${pkgs.libcap}/bin/setcap CAP_SYS_NICE+eip ${pkgs.monado}/bin/monado-service"; # not needed with monado.highPriority
    };

    services.udev.packages = with pkgs; [
      xr-hardware
      plusultra.nofio-usb-udev-rules
    ];

    services.monado = {
      package = inputs.nixpkgs-xr.packages.${pkgs.system}.monado;
      enable = true;
      defaultRuntime = cfg.monadoDefaultEnable;
      highPriority = true;
    };

    systemd.user.services.monado = {
      # serviceConfig = {
      #   ExecStartPost = "${lib.getExe pkgs.lighthouse-steamvr} -s ON";
      #    ExecStopPost = "${lib.getExe pkgs.lighthouse-steamvr} -s OFF";
      # };
      environment = {
        STEAMVR_PATH = "${home}/.steam/root/steamapps/common/SteamVR";
        STEAM_LH_ENABLE = "1";
        # 20250413 current monado nixpkg says SURVIVE_ variables aren't needed?
        # SURVIVE_GLOBALSCENESOLVER = "0";
        # SURVIVE_TIMECODE_OFFSET_MS = "-6.94";
        XRT_COMPOSITOR_COMPUTE = "1";
        XRT_COMPOSITOR_SCALE_PERCENTAGE = "140";
        WMR_HANDTRACKING = "0"; # Index doesn't do handtracking, and the cameras don't exactly work
        AMD_VULKAN_ICD = "RADV";
      };
    };

    environment.sessionVariables = {
      # why is this necessary? which one is more correct?
      # LIBMONADO_PATH = "${config.services.monado.package}/lib/libmonado.so";
      LIBMONADO_PATH = "${pkgs.monado}/lib/libmonado.so";
      XR_RUNTIME_JSON = "$XDG_CONFIG_HOME/openxr/1/active_runtime.json";
      PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
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
        monado
        opencomposite
      ];
    };

    hardware.graphics.extraPackages = with pkgs; [
    ];

    programs.envision.enable = true;

    environment.systemPackages = with pkgs; [
      lighthouse-steamvr
      inputs.nixpkgs-xr.packages.${pkgs.system}.index_camera_passthrough
      # monado-vulkan-layers
      wlx-overlay-s
      opencomposite
      libsurvive
      # motoc
      # basalt-monado
      xrgears
      xrizer
      # xr-hardware
      corectrl
      gamemode
      openxr-loader

      stardust-xr-atmosphere
      stardust-xr-sphereland
      stardust-xr-protostar
      stardust-xr-flatland
      stardust-xr-magnetar
      stardust-xr-phobetor
      stardust-xr-gravity
      # stardust-xr-server # 20250412 has error not finding libuuid when opening active_runtime.json
      plusultra.stardust-xr-server
      stardust-xr-kiara
    ];

    
    # boot.kernelPatches = [
    #   {
    #     name = "amdgpu-ignore-ctx-privileges";
    #     patch = pkgs.fetchpatch {
    #       name = "cap_sys_nice_begone.patch";
    #       url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
    #       hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
    #     };
    #   }
    # ];
  };
}
