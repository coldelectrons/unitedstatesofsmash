{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.hardware.vr;
in
{
  options.${namespace}.apps.vr = {
    enable = mkEnableOption "Enable user VR configuration";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
      ];

      sessionVariables = {
        LIBMONADO_PATH = "${config.services.monado.package}/lib/libmonado.so";
      };

    };

    xdg.configFile = {
      "openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";

      "openvr/openvrpaths.vrpath".text = ''
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
    };

    home.file = {
      "${xdg_data_home}/monado/hand-tracking-models".source = pkgs.fetchgit {
        url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models.git";
        fetchLFS = true;
        hash = "sha256-x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
      };
    };
  };
}
