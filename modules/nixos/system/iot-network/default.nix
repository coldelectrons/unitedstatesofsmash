{
  lib,
  pkgs,
  config,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.system.iot-network;

  domainName = "local";
in
{
  options.${namespace}.system.iot-network = with types; {
    enable = mkBoolOpt false "Whether or not to configure IoT vlan networking";
    interface = mkOpt (types.nullOr types.str) null "Interface to attach vlan to.";
  };

  config = mkIf cfg.enable {

    networking.vlans = {
      default = {
        id = 1;
        interface = cfg.interface;
      };
      iot = {
        id = 2;
        interface = cfg.interface;
      };
    };

    networking.interfaces = [
      {
        name = "default";
        useDCHP = true;
      }
      {
        name = "iot";
        useDCHP = true;
      }
    ];
    
  };
}
