{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.vr;

  # TODO get this from the overall config sessionVariables
  # isn't this set over in modules/nixos/system/env?
  userHome = config.${namespace}.user.home;
  xdg_data_home = "${userHome}/.local/share";
  xdg_runtime_dir = "/run/user/1000";
in
{
  options.${namespace}.apps.vr = {
    enable = mkEnableOption "Enable user VR configuration";
    handTrackingModels = mkEnableOption "Fetch and install Monado hand tracking models";
    # nofiowireless = mkEnableOption "add config file for Nofio Wireless virtualhere claptrap";
  };

  config = mkIf cfg.enable rec {
    home = {
      packages = with pkgs; [
      ];

      sessionVariables = {
        LIBMONADO_PATH = "${pkgs.monado}/lib/libmonado.so";
        XR_RUNTIME_JSON = "{$xdg_data_home}/openxr/1/active_runtime.json";
        PRESSURE_VESSEL_FILESYSTEMS_RW = "${xdg_runtime_dir}/monado_comp_ipc";
      };

    };

    xdg.configFile = {
      # manually symlink one of these two files
      "openxr/1/active_runtime.json.monado".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
      "openxr/1/active_runtime.json.steamvr".text = ''
{
  "file_format_version": "1.0.0",
  "runtime": {
    "VALVE_runtime_is_steamvr": true,
    "MND_libmonado_path": null,
    "library_path": "/home/coldelectrons/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrclient.so",
    "name": "SteamVR"
  }
}% 
      '';
      # manually symlink one of these two files
      "openvr/openvrpaths.vrpath.opencomposite".text = ''
{
  "config" :
  [
    "${xdg_data_home}/Steam/config"
  ],
  "external_drivers" : null,
  "jsonid" : "vrpathreg",
  "log" :
  [
    "${xdg_data_home}/Steam/logs"
  ],
  "runtime" :
  [
    "${pkgs.opencomposite}/lib/opencomposite"
  ],
  "version" : 1
}
      '';
      "openvr/openvrpaths.vrpath.steamvr".text = ''
{
  "config" :
  [
    "${xdg_data_home}/Steam/config"
  ],
  "external_drivers" : null,
  "jsonid" : "vrpathreg",
  "log" :
  [
    "${xdg_data_home}/Steam/logs"
  ],
  "runtime" :
  [
    "${xdg_data_home}/Steam/steamapps/common/SteamVR"
  ],
  "version" : 1
}
      '';
    };

    home.file = mkIf cfg.handTrackingModels {
      "${xdg_data_home}/monado/hand-tracking-models".source = pkgs.fetchgit {
        url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models.git";
        fetchLFS = true;
        hash = "sha256-x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
      };
    };
  };
}
