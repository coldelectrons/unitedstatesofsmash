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
  cfg = config.${namespace}.services.home-assistant;

  # esphome updated to 2024.12.2 just days after
  # nixos 24.11 released, leaving stable with esphome 2024.11.3
  # but 2024.12.2 is in unstable
  haPkg = inputs.unstable.legacyPackages."${pkgs.system}".home-assistant;
in
{
  options.${namespace}.services.home-assistant = with types; {
    enable = mkBoolOpt false "Whether or not to configure home-assistant";
    proxy = mkBoolOpt false "Proxy home-assistant through nginx";
  };

  config = mkIf cfg.enable {

    # environment.systemPackages = [ haPkg ];

    services.home-assistant = {
      enable = true;
      package = haPkg;
      configWritable = true;
      configDir = "/etc/home-assistant";
      lovelaceConfig = null;
      config = {
        default_config = { };
      #   http = {
      #     # server_host = "127.0.0.1";
      #     server_host = "0.0.0.0";
      #     use_x_forwarded_for = true;
      #     trusted_proxies = [ "::1" "127.0.0.1" ];
      #   };
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
      #   # mqtt = "!include mqtt.yaml";
        logger = {
          default = "info";
        };
        recorder.db_url = "postgresql://@/hass";
      };
      # extraPackages = with pkgs; [ psycopg2 ];
      extraPackages = python3packages:
        with python3packages; [
          # postgresql support
          psycopg2
          numpy
          hassil
          aioesphomeapi
          # esphome-dashboard-api
          zeroconf
          ssdp
        ];
      extraComponents = [
        "default_config"
        "esphome"
        "bluetooth"
        "hue"
        "usb"
        "mobile_app"
        "zeroconf"
        "ssdp"
        "sun"
        "automation"
        "emoncms"
        "emoncms_history"
      ];
      # For some reason, my configuration.yaml gets these with an absolute "/local/nixos-lovelace-ui-modules/xxxx"
      # but they are linked into ${configDir}/www/nixos-lovelace-ui-modules/xxxx
      # XXX WTF
      customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
        card-mod
        button-card
        light-entity-card
        mushroom
        template-entity-row
        bubble-card
      ];
    };

    systemd.tmpfiles.rules = [
      "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
      "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
    ];
    # services.home-assistant.config.homeassistant.auth_providers = [
    #   { type = "homeassistant"; }
    #   {
    #     type = "trusted_networks";
    #     trusted_networks = [ "192.168.1.0/24" ];
    #     allow_bypass_login = true;
    #   }
    # ];

    # systemd.services.home-assistant.preStart = ''
    #   ${pkgs.nix}/bin/nix eval --raw -f ${config.sops.secrets."services/bn-smarthome/hass-mqtt-yaml.nix".path} yaml > /var/lib/hass/mqtt.yaml
    # '';

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      ensureDatabases = [ "hass" ];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
    };

    networking.firewall = {
      allowedUDPPorts = [
        5353 # mdns
      ];
      allowedTCPPorts = [ 8123 ];
    };

  };
}


