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
  amdpkgs = with pkgs; [
    lact
    radeontop
    # umr
    rocmPackages.clr
    rocmPackages.clr.icd
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
  ];
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
      vulkan-loader
      vkdisplayinfo
      gpu-viewer
      mesa
      clinfo # for kinfocenter for OpenCL page
      glxinfo # for kinfocenter for OpenGL EGL and GLX page
    ]
    ++ optionals cfg.amdgpu.enable amdpkgs;

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          libva
          vulkan-validation-layers
          vulkan-extension-layer
          monado-vulkan-layers
        ] ++ optionals cfg.amdgpu.enable amdpkgs;
      };
      amdgpu.amdvlk = mkIf cfg.amdgpu.enable {
        enable = true;
        support32Bit.enable = true;
        supportExperimental.enable = true;
      };
    };
  };
}
