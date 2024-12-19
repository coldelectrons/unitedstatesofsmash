{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.vr;
  user = config.${namespace}.user;
  home = config.users.users.${user.name}.home;
in
{
  options.${namespace}.hardware.vr = with types; {
    enable = mkBoolOpt false "Whether or not to enable VR/XR support.";
  };

  config = mkIf cfg.enable {

    # Fixes issue with SteamVR not starting
    system.activationScripts = {
      fixSteamVR =
        "${pkgs.libcap}/bin/setcap CAP_SYS_NICE+ep ${home}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
    };

    hardware.steam-hardware.enable = true;
    # hardware.graphics.extraPackages = with pkgs; [ monado-vulkan-layers ]; # TODO is this causing my problems?

    services.monado = {
      enable = true;
      defaultRuntime = true;
    };
    systemd.user.services.monado.environment = {
      STEAM_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    services.udev.packages = with pkgs; [ xr-hardware ];

    environment.systemPackages = with pkgs; [
      plusultra.virtualhere # for the nofio wireless adapter
      # wlx-overlay-s
      steam-run
      lighthouse-steamvr
      # motoc
      # basalt-monado
      # opencomposite
      # opencomposite-hand-fixes
      # opencomposite-vendored
      # index_camera_passthrough # TODO doesn't seem to be available from nixpkgs-xr 20241206
      xrgears
      xr-hardware

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
  };
}
