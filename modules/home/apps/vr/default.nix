{
  lib,
  config,
  pkgs,
  namespace,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  monado_pkg = inputs.nixpkgs-xr.packages.${pkgs.system}.monado;
  # monado_pkg = config.services.monado.package;

  cfg = config.${namespace}.apps.vr;

  # TODO get this from the overall config sessionVariables
  # isn't this set over in modules/nixos/system/env?
  # userHome = config.${namespace}.user.home;
  # xdg_data_home = "${userHome}/.local/share";
  xdg_data_home = config.home.sessionVariables.XDG_DATA_HOME;
in
{
  options.${namespace}.apps.vr = {
    enable = mkEnableOption "Enable user VR configuration";
    handTrackingModels.enable = mkEnableOption "Fetch and install Monado hand tracking models";
    # nofiowireless = mkEnableOption "add config file for Nofio Wireless virtualhere claptrap";
  };

  config = mkIf cfg.enable rec {
    home = {
      packages = with pkgs; [
        ( pkgs.writeShellApplication {
            name = "vrpathreg-steamvr-monado";
            checkPhase = "";
            runtimeInputs = with pkgs; [ steam-run steam monado ];
            text = ''
              ${pkgs.steam-run}/bin/steam-run ~/.local/share/Steam/steamapps/common/SteamVR/bin/vrpathreg.sh adddriver ${pkgs.monado}/share/steamvr-monado
            '';
        })
      ];

      sessionVariables = {
        # LIBMONADO_PATH = "${pkgs.monado}/lib/libmonado.so";
        # XR_RUNTIME_JSON = "$XDG_CONFIG_HOME/openxr/1/active_runtime.json";
        # PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
      };

    };

    xdg.configFile = {
      # manually symlink one of these two files
      "openxr/1/active_runtime.json.monado".source = "${monado_pkg}/share/openxr/1/openxr_monado.json";
      "openxr/1/active_runtime.json.steamvr".text = ''
        {
          "file_format_version": "1.0.0",
          "runtime": {
            "VALVE_runtime_is_steamvr": true,
            "library_path": "/home/coldelectrons/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrclient.so",
            "name": "SteamVR"
          }
        }% 
      '';
            # "MND_libmonado_path": null,
            # "MND_libmonado_path": "${monado_pkg}/lib/libmonado.so"
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
            "/home/coldelectrons/.local/share/Steam/steamapps/common/SteamVR"
          ],
          "version" : 1
        }
      '';
    };

    home.file = mkIf cfg.handTrackingModels.enable {
      "${xdg_data_home}/monado/hand-tracking-models".source = pkgs.fetchgit {
        url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models.git";
        fetchLFS = true;
        hash = "sha256-x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
      };
    };
  };
}
