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
    hardware.steam-hardware.enable = true;
    # services.wivrn.enable = true; # availble starting 24.11??
    environment.systemPackages = with pkgs; [
      wlx-overlay-s
      steam-run
      lighthouse-steamvr
      monado
      monado-vulkan-layers # TODO enable when 24.11
      motoc # TODO enable when 24.11
      # basalt-monado
      envision-unwrapped
      opencomposite
      # opencomposite-hand-fixes
      # opencomposite-vendored
      index_camera_passthrough
    ];
  };
}
