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
  gpuIds = [
    "1002:744C-1EAE:7905-0000:11:00.0"
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
        ] ++ optionals cfg.amdgpu.enable amdpkgs;
      };
      amdgpu.amdvlk = mkIf cfg.amdgpu.enable {
        enable = true;
        support32Bit.enable = true;
        supportExperimental.enable = true;
      };
    };

    systemd.services.lactd = mkIf cfg.amdgpu.enable {
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      description = "AMDGPU Control Daemon";
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
    };

    environment.etc."lact/config.yaml".text =
      let
        gpuConfig = # yaml
          ''
            fan_control_enabled: true
            fan_control_settings:
              mode: curve
              static_speed: 0.5
              temperature_key: edge
              interval_ms: 500
              curve:
                60: 0.0
                70: 0.5
                75: 0.6
                80: 0.65
                90: 0.75
            pmfw_options:
              acoustic_limit: 3300
              acoustic_target: 2000
              minimum_pwm: 15
              target_temperature: 80
            # Run at 257 for slightly better performance but louder fans
            power_cap: 231.0
            performance_level: manual
            max_core_clock: 2394
            voltage_offset: -30
            power_profile_mode_index: 0
            power_states:
              memory_clock:
              - 0
              - 1
              - 2
              - 3
              core_clock:
              - 0
              - 1
              - 2
          '';
      in
      # yaml
      ''
        daemon:
          log_level: info
          admin_groups:
          - wheel
          - sudo
          disable_clocks_cleanup: false
        apply_settings_timer: 5
        gpus:
        ${concatMapStrings (gpuId: ''
          # anchor for correct indendation
            ${gpuId}:
              ${replaceStrings [ "\n" ] [ "\n    " ] gpuConfig}
        '') gpuIds}
      '';

  # WARN: Disable this if you experience flickering or general instability
  # https://wiki.archlinux.org/title/AMDGPU#Boot_parameter
    boot.kernelParams = mkIf cfg.amdgpu.enable [ "amdgpu.ppfeaturemask=0xffffffff" ];
    
    # boot.extraModulePackages = mkIf cfg.amdgpu.enable [
    #   (pkgs.plusultra.amdgpu-kernel-module.overrideAttrs (_: {
    #     kernel = config.boot.kernelPackages.kernel;
    #     patches = [
    #       (pkgs.fetchpatch {
    #         name = "cap_sys_nice_begone.patch";
    #         url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
    #         hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
    #       })
    #     ];
    #   }))
    # ];

    # boot.kernelPatches = mkIf cfg.amdgpu.enable [
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
