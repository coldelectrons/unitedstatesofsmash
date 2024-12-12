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
  cfg = config.${namespace}.services.usbip;

  device = types.submodule {
    options = {
      host = mkOption types.str;
      device = mkOption types.str;
    };
  };
in
{
  options.${namespace}.services.usbip = {
    enable = mkEnableOption "usbip client";
    kernelModule = mkOption {
      type = types.package;
      default = config.boot.kernelPackages.usbip;
    };
    devices = mkOption {
      type = types.listOf devcie;
      default = [];
      description = "list of host/devices to attach";
      example = {
        host = "myhost.local";
        device = "blah";
      };
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ cfg.kernelModule ];
    boot.kernelModules = [ "vhci-hcd" ];
    systemd.services = (builtins.listToAttrs (map (dev: { name = "usbip-${dev.host}-${dev.device}" }; value = {
          wantedBy = [ "network.target" ];
          script = ''
            devices=$(${cfg.kernelModule}/bin/usbip list -r ${dev.host} | grep -E ".*(${dev.device})" )
            ${cfg.kernelModule}/bin/usbip -d attach -r ${dev.host} -b $(echo $devices | ${pkgs.gawk}/bin/awk '{ print substr($1, 1, length($1)-1) }')
          '';
          preStop = ''
            devices=$(${cfg.kernelModule}/bin/usbip port | grep -B 1 -E ".*(${dev.device})" | grep "Port" )
            ${cfg.kernelModule}/bin/usbip -d detach -p $(echo $devices | ${pkgs.gawk}/bin/awk '{ print substr($2, 1, length($2)-1) }')
          '';
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true;
        };
      }) cfg.devices ));
  };
}
