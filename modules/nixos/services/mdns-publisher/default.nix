{
  config,
  options,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (builtins) toString;
  inherit (lib) types;

  cfg = config.${namespace}.services.mdns-publisher;

  mdns-publisher = pkgs.${namespace}.mdns-publisher;
in
with lib;
{
  options.${namespace}.services.mdns-publisher = {
    enable = lib.mkEnableOption "Enable mdns publishing of list of domains.";
    # domain = mkOption {
    #   type = types.str;
    #   default = "local";
    # };
    names = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "List of names to publish as CNAMEs for localhost.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [ ];

    environment.systemPackages = [ mdns-publisher ];

    systemd.services.mdns-publish-cname = {
      after = [ "network.target" "avahi-daemon.service" ];
      description = "Avahi/mDNS CNAME publisher";
      enable = cfg.names != [ ];
      serviceConfig = {
        # Until https://github.com/systemd/systemd/issues/22737 gets fixed
        DynamicUser = false;
        Type = "simple";
        WorkingDirectory = "/var/empty";
        ExecStart = ''${mdns-publisher}/bin/mdns-publish-cname --ttl 20 ${concatStringsSep " " cfg.names}'';
        Restart = "no";
        PrivateDevices = true;
      };
      wantedBy = [ "multi-user.target" ];
    };


    networking.firewall = {
      allowedUDPPorts = [
        5353
      ];
    };
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
        domain = true;
      };
    };
  };
}

