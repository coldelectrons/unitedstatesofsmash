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
    vulkan = mkBoolOpt false "Whether or not to enable vulkan support";
    amd = mkBoolOpt false "Whether or not to enable amd support";
    nvidia = mkBoolOpt false "Whether or not to enable nvidia support";
  };

  config = mkIf cfg.enable {
    plusultra.user.extraGroups = [ "video" ];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          # rocmPackages.clr.icd
          # vulkan-loader
          # vulkan-validation-layers
          # vulkan-extension-layer
        ];
      };
    };
  };
}
