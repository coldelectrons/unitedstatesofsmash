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
      config = {
        default_config = { };
        http = {
          # server_host = "127.0.0.1";
          server_host = "0.0.0.0";
          use_x_forwarded_for = true;
          trusted_proxies = [ "::1" "127.0.0.1" ];
        };
        # automation = "!include automations.yaml";
        # scene = "!include scenes.yaml";
        # mqtt = "!include mqtt.yaml";
        logger = {
          default = "info";
        };
      };
      # extraPackages = with pkgs; [ psycopg2 ];
      extraPackages = python3packages:
        with python3packages; [
          # postgresql support
          psycopg2
        ];

      extraComponents = [
        "blueprint"
        "bluetooth"
        "bluetooth_adapters"
        "bluetooth_le_tracker"
        "bluetooth_tracker"
        "mqtt"
        "esphome"
        "hue"
      ];
    };


    services.home-assistant.config.homeassistant.auth_providers = [
      # { type = "homeassistant"; }
      {
        type = "trusted_networks";
        trusted_networks = [ "192.168.1.0/24" ];
        allow_bypass_login = true;
      }
    ];

    # systemd.services.home-assistant.preStart = ''
    #   ${pkgs.nix}/bin/nix eval --raw -f ${config.sops.secrets."services/bn-smarthome/hass-mqtt-yaml.nix".path} yaml > /var/lib/hass/mqtt.yaml
    # '';

    services.home-assistant.config = {
      recorder.db_url = "postgresql://@/hass";
    };
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


