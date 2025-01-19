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
  cfg = config.${namespace}.services.esphome;

  # esphome updated to 2024.12.2 just days after
  # nixos 24.11 released, leaving stable with esphome 2024.11.3
  # but 2024.12.2 is in unstable
  ehPkg = inputs.unstable.legacyPackages."${pkgs.system}".esphome;

  roleName = "esphome";
  domainName = "local";
in
{
  options.${namespace}.services.esphome = with types; {
    enable = mkBoolOpt false "Whether or not to configure esphome";
    proxy = mkBoolOpt false "Proxy esphome through nginx";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ ehPkg ];

    services.esphome = {
      enable = true;
      address = "0.0.0.0";
      enableUnixSocket = cfg.proxy;
      openFirewall = true;
      package = ehPkg;
    };

    networking.firewall = {
      allowedUDPPorts = [
        5353 # mdns for esphome
      ];
    };

    systemd.services.nginx = mkIf cfg.proxy {
      serviceConfig.SupplementaryGroups = [ "esphome" ];
      requires = [ "esphome.service" ];
    };
    
    # ???
    #systemd.services.nginx.serviceConfig.ProtectHome = false;

    services.nginx = mkIf cfg.proxy {
      upstreams."esphome" = {
        servers."unix:/run/esphome/esphome.sock" = { };
        extraConfig = ''
          zone esphome 64k;
          keepalive 2;
        '';
      };
      virtualHosts."${roleName}.${domainName}" = {
        serverName = "${roleName}.${domainName}";
        # sslCertificate = config.age.secrets."nginx-selfsigned.cert".path;
        # sslCertificateKey = config.age.secrets."nginx-selfsigned.key".path;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://esphome";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
}

