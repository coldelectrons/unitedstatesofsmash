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
in
{
  options.${namespace}.hardware.vr = with types; {
    enable = mkBoolOpt false "Whether or not to enable VR/XR support.";
  };

  config = mkIf cfg.enable {

    # Fixes issue with SteamVR not starting
    system.activationScripts = {
      fixSteamVR =
        "${pkgs.libcap}/bin/setcap CAP_SYS_NICE+ep /home/${user}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
    };

    hardware.steam-hardware.enable = true;
    hardware.graphics.extraPackages = with pkgs; [ monado-vulkan-layers ];
    programs.envision.enable = true;
    # services.wivrn.enable = true; # availble starting 24.11??

    services.monado = {
      enable = true;
      defaultRuntime = true;
    };
    systemd.user.services.monado.environment = {
      STEAM_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    environment.systemPackages = with pkgs; [
      wlx-overlay-s
      steam-run
      lighthouse-steamvr
      monado
      monado-vulkan-layers
      motoc
      # basalt-monado
      envision-unwrapped
      opencomposite
      # opencomposite-hand-fixes
      # opencomposite-vendored
      # index_camera_passthrough # TODO doesn't seem to be available from nixpkgs-xr 20241206
    ];
  };
}
