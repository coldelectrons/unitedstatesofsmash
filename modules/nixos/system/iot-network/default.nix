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
in
{
  options.${namespace}.system.iot-network = with types; {
    enable = mkBoolOpt false "Whether or not to configure IoT vlan networking";
    interface = mkOpt (types.nullOr types.str) null "Interface to attach vlan to.";
  };

  config = mkIf cfg.enable {

    systemd.network = {
      enable = true;

      netdevs = {
        "20-vlan2" = {
          enable = true;
          netdevConfig = {
            Name = "vlan2";
            Kind = "vlan";
            Description = "IoT network";
          };
          vlanConfig.Id = 2;
        };
      };
      networks = {
        "00-wired" = {
          enable = true;
          matchConfig.Name = cfg.interface;
          vlan = [ "vlan2" ];
          networkConfig = {
            DHCP = "ipv4";
            LinkLocalAddressing = "no";
          };
          linkConfig.RequiredForOnline = "yes";
          dhcpV4Config.UseDomains = "yes";
        };
        "01-iot" = {
          matchConfig.Name = "vlan2";
          networkConfig = {
            DHCP = "ipv4";
            LinkLocalAddressing = "no";
            ConfigureWithoutCarrier = true;
          };
          linkConfig.RequiredForOnline = "no";
        };
      };
    };

    services.resolved.enable = true;


    # networking.vlans = {
    #   default = {
    #     id = 1;
    #     interface = cfg.interface;
    #   };
    #   iot = {
    #     id = 2;
    #     interface = cfg.interface;
    #   };
    # };

    # networking.interfaces = [
    #   {
    #     name = "default";
    #     useDCHP = true;
    #   }
    #   {
    #     name = "iot";
    #     useDCHP = true;
    #   }
    # ];
    
  };
}
