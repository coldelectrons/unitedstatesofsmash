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
    amdgpu = { 
      enable = mkBoolOpt false "Whether or not to enable amdgpu support";
    };
    nvidia = {
      enable = mkBoolOpt false "Whether or not to enable nvidia support";
    };
  };

  config = mkIf cfg.enable {
    plusultra.user.extraGroups = [ "video" ];
    environment.systemPackages = with pkgs; [
      vulkan-tools
    ]
    ++ ( optional cfg.amdgpu.enable lact )
    ++ ( optional cfg.amdgpu.enable radeontop )
    ++ ( optional cfg.amdgpu.enable umr );

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      amdgpu.amdvlk = mkIf cfg.amdgpu.enable {
        enable = true;
        support32Bit.enable = true;
      };
    };
  };
}
