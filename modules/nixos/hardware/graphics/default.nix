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
  cfg = config.${namespace}.hardware.graphics;
in
{
  options.${namespace}.hardware.graphics = with types; {
    enable = mkBoolOpt false "Whether or not to enable graphics support";
  };

  config = mkIf cfg.enable {
    plusultra.user.extraGroups = [ "video" ];
    environment.systemPackages = with pkgs; [
      lact
      radeontop
      umr
      vulkan-tools
    ];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      amdgpu.amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
    };
  };
}
