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

  cfg = config.${namespace}.apps.stardust-xr;

  # TODO get this from the overall config sessionVariables
  # isn't this set over in modules/nixos/system/env?
  # userHome = config.${namespace}.user.home;
  # xdg_data_home = "${userHome}/.local/share";
  xdg_data_home = config.home.sessionVariables.XDG_DATA_HOME;
in
{
  options.${namespace}.apps.stardust-xr = {
    enable = mkEnableOption "Enable home stardust-xr configuration";
  };

  config = mkIf cfg.enable rec {
    home = {
      packages = with pkgs; [
        stardust-xr-atmosphere
        stardust-xr-sphereland
        stardust-xr-protostar
        stardust-xr-flatland
        stardust-xr-magnetar
        stardust-xr-phobetor
        stardust-xr-gravity
        stardust-xr-server
        stardust-xr-kiara
        xwayland-satellite
        (pkgs.writeShellScriptBin "stardust_startup" ''
          unset LD_LIBRARY_PATH
          if [[ -v LD_LIBRARY_PATH_ORIGINAL ]]; then
            echo "Restored pre-exisiting LD_LIBRARY_PATH"
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH_ORIGINAL"
          fi

          ${pkgs.xwayland-satellite}/bin/xwayland-satellite :10 &
          export DISPLAY=:10 &
          sleep 0.1;


          ${pkgs.stardust-xr-flatland}/bin/flatland &
          ${pkgs.stardust-xr-gravity}/bin/gravity -- 0 0.0 -0.5 ${pkgs.stardust-xr-protostar}/bin/hexagon_launcher &
          # ${pkgs.stardust-xr-blackhole}/bin/black-hole &
        '')
        (pkgs.writeShellScriptBin "stardust" ''
          ${pkgs.stardust-xr-server}/bin/stardust-xr-server -o 1 -e stardust_startup "$@"
        '')
        # (pkgs.makeDesktopItem {
        #   name = "start stardustxr";
        #   desktopName = "Start StardustXR";
        #   type = "Application";
        #   exec = getExe (writeShellScriptBin "stardust" ''
        #     ${pkgs.stardust-xr-server}/bin/stardust-xr-server -o 1 -e stardust_startup "$@"
        #   '');
        #   categories = [ "Games" "X-VR" ];
        # })
      ];

      sessionVariables = {
        # LIBMONADO_PATH = "${pkgs.monado}/lib/libmonado.so";
        # XR_RUNTIME_JSON = "$XDG_CONFIG_HOME/openxr/1/active_runtime.json";
        # PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
      };

    };

  };
}

