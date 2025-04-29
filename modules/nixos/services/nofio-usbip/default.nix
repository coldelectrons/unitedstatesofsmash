{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.nofio-usbip;
  
  device = types.submodule {
    options = {
      name = mkOption { type = types.str; };
      device = mkOption { type = types.str; };
    };
  };
in
{
  options.${namespace}.services.nofio-usbip = {
    enable = mkEnableOption "Service to attach Nofio device with usbip";
    kernelModule = mkOption {
      type = types.package;
      default = config.boot.kernelPackages.usbip;
    };
    host = mkOption {
      type = types.str;
      default = "192.168.3.1";
    };
    tcpPort = mkOption {
      type = types.str;
      default = "7575";
    };
    devices = mkOption {
      type = types.listOf device;
      default = [
        {
          name = "valve_vr_radio";
          device = "28de:2102";
        }
        {
          name = "valve_index_controller";
          device = "28de:2300";
        }
        {
          name = "valve_lh_receiver";
          device = "28de:2000";
        }
      ];
      description = "list of devices to attach";
      example = [
        {
          name = "valve_vr_radio";
          device = "28de:2102";
        }
        {
          name = "valve_index_controller";
          device = "28de:2300";
        }
        {
          name = "valve_lh_receiver";
          device = "28de:2000";
        }
      ];
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [ usbip ];
    boot.kernelModules = [ "vhci-hcd" ];
    systemd.services = (builtins.listToAttrs (map (dev: { name = "nofio-${dev.name}-${dev.device}"; value = {
          wantedBy = [ "network.target" ];
          script = ''
            devices=$(${cfg.kernelModule}/bin/usbip list -r ${cfg.host} --tcp-port ${cfg.tcpPort} | grep -E ".*(${dev.device})" )
            ${cfg.kernelModule}/bin/usbip -d attach -r ${cfg.host} --tcp-port ${cfg.tcpPort} -b $(echo $devices | ${pkgs.gawk}/bin/awk '{ print substr($1, 1, length($1)-1) }')
          '';
          preStop = ''
            devices=$(${cfg.kernelModule}/bin/usbip port | grep -B 1 -E ".*(dev.device)" | grep "Port" )
            ${cfg.kernelModule}/bin/usbip -d detach -p $(echo $devices | ${pkgs.gawk}/bin/awk '{ print substr($2, 1, length($2)-1) }')
          '';
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true;
        };
      }) cfg.devices ));
  };
}
