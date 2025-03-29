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
  cfg = config.${namespace}.hardware.nofio-wireless;
  user = config.${namespace}.user;
  home = config.users.users.${user.name}.home;
in
{
  options.${namespace}.hardware.nofio-wireless = with types; {
    enable = mkBoolOpt false "Whether or not to enable Nofio Wireless support.";
  };

  config = mkIf cfg.enable {

    boot.kernelModules = [ "vhci-hcd" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [ usbip ];
    

    environment.systemPackages = with pkgs; [
      plusultra.virtualhere-cli
    ];

    networking.firewall = {
      allowedUDPPorts = [
        7575
      ];
      allowedTCPPorts = [
        7575
      ];
    };

    environment.etc."nofio/vhui.ini".text = ''
      [General]
      HideMenuItems=VHTBI
      [Transport]
      EasyFindId=123
      EasyFindPin=123
      [Settings]
      ManualHubs=192.168.3.1:7575
      [AutoShare]
      All=1
      AutoRefreshLookupPeriod=5
      BonjourLookupTimeout=4
      BonjourResolverTimeout=2
    '';

    systemd.services."nofio-wireless" = {
      description = "Daemon for the Nofio Virtualhere claptrap";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        PIDFile="/var/run/nofio-wireless.pid";
        ExecStart = "${pkgs.plusultra.virtualhere-cli}/bin/vhclientx86_64 -c /etc/nofio/vhui.ini -n";
      };
    };
  };
}
