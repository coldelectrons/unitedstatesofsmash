{ pkgs
, config
, lib
, channel
, namespace
, inputs
, ...
}:
with lib;
with lib.${namespace};
{
  imports = [ ./hardware.nix ];

  # Resolve an issue with hades's wired connections failing sometimes due to weird
  # DHCP issues. I'm not quite sure why this is the case, but I have found that the
  # problem can be resolved by stopping dhcpcd, restarting Network Manager, and then
  # unplugging and replugging the ethernet cable. Perhaps there's some weird race
  # condition when the system is coming up that causes this.
  networking.dhcpcd.enable = false;


  boot = {
    binfmt.emulatedSystems = [  ];
    consoleLogLevel = 0;
    kernelParams = [ 
    ];                                                                                                                                   
    # plymouth.enable = true;
    # Swapfile hibernate
    # resumeDevice = "${MAIN_PART}";
    # kernelParams = [ "resume_offset=${RESUME_OFFSET}" "nvidia_drm.fbdev=1" ];
  };

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    bluetui
    bluetuith
    bluez-tools
    bluewalker
    python312Packages.bleak
    python312Packages.bleak-esphome
    impala
    python312Packages.openevsewifi
    dbmonster
    ifwifi
    python312Packages.meshtastic
    loramon
    home-assistant-cli
  ];

  services.esphome.enable = true;

  services.mosquitto.enable = true;

  services.home-assistant = {
    enable = true;
    configWritable = true;
    config = {
      homeassistant = {
        name = "Shop";
        unit_system = "metric";
        currency = "USD";
        time_zone = "America/New_York";
        external_url = "https://fatso.destinesia.xyz";
        internal_url = "https://fatso.local";
        lattitude = 40.440013;
        longitude = -81.599193;
        elevation = 300;
      };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "::1" "127.0.0.1" ];
      };
      automation = "!include automations.yaml";
      scene = "!include scenes.yaml";
      mqtt = "!include mqtt.yaml";
      logger = {
        default = "info";
      };
      default_config = { };
    };
    extraComponents = [
      "accuweather"
      "air_quality"
      "alarm_control_panel"
      "alert"
      "ambient_network"
      "ambient_station"
      "analytics"
      "analytics_insights"
      "apcupsd"
      "api"
      "application_credentials"
      "apprise"
      "arest"
      "arwn"
      "auth"
      "automation"
      "backup"
      "bayesian"
      "binary_sensor"
      "blebox"
      "blink"
      "blueprint"
      "bluetooth"
      "bluetooth_adapters"
      "bluetooth_le_tracker"
      "bluetooth_tracker"
      # "browser"
      "button"
      "calendar"
      "camera"
      "cert_expiry"
      # "channels"
      "climate"
      # "cloud"
      "co2signal"
      "color_extractor"
      "command_line"
      "compensation"
      "config"
      "configurator"
      # "conversation"
      "counter"
      "cover"
      "cpuspeed"
      # "cups"
      "date"
      "datetime"
      # "debugpy"
      "deconz"
      # "decora"
      # "decora_wifi"
      "default_config"
      "derivative"
      "device_automation"
      "device_sun_light_trigger"
      "device_tracker"
      "dhcp"
      "diagnostics"
      "digital_loggers"
      # "digital_ocean"
      # "dlib_face_detect"
      # "dlib_face_identify"
      # "dlink"
      "dnsip"
      # "doods"
      "downloader"
      # "dsmr"
      # "dsmr_reader"
      "duckdns"
      "emoncms"
      "emoncms_history"
      "energy"
      "esphome"
      "event"
      "evergy"
      "fail2ban"
      "fan"
      "fastdotcom"
      # "feedreader"
      # "ffmpeg"
      # "ffmpeg_motion"
      # "ffmpeg_noise"
      "file"
      "file_upload"
      "filesize"
      "filter"
      # "firmata"
      # "flux"
      # "flux_led"
      # "folder"
      # "folder_watcher"
      # "forecast_solar"
      # "foscam"
      # "freedns"
      "frontend"
      "generic"
      "generic_hygrostat"
      "generic_thermostat"
      "geo_json_events"
      "geo_location"
      "geo_rss_events"
      # "geocaching"
      # "geofency"
      # "github"
      # "gitlab_ci"
      # "gitter"
      # "go2rtc"
      # "google_mail"
      # "gpsd"
      # "gpslogger"
      # "graphite"
      "group"
      # "gstreamer"
      "hardware"
      "hassio"
      "haveibeenpwned"
      "hddtemp"
      "history"
      "history_stats"
      "holiday"
      "homeassistant"
      "homeassistant_alerts"
      "homeassistant_hardware"
      # "html5"
      "http"
      "hue"
      "humidifier"
      "image"
      "image_processing"
      "image_upload"
      "imap"
      "input_boolean"
      "input_button"
      "input_datetime"
      "input_number"
      "input_select"
      "input_text"
      "integration"
      "intent"
      "intent_script"
      "ios"
      # "iotawatt"
      # "iotty"
      # "iperf3"
      # "ipp"
      # "iron_os"
      "isal"
      # "iss"
      # "jellyfin"
      "keyboard"
      "keyboard_remote"
      "kitchen_sink"
      "lawn_mower"
      "led_ble"
      "light"
      "lightwave"
      "linux_battery"
      "local_calendar"
      "local_file"
      "local_ip"
      "local_todo"
      "lock"
      "logbook"
      "logentries"
      "logger"
      # "lovelace"
      # "luci"
      # "madvr"
      # "mailgun"
      "manual"
      "manual_mqtt"
      "mastodon"
      # "media_extractor"
      # "media_player"
      # "media_source"
      "min_max"
      "minecraft_server"
      "mjpeg"
      # "moat"
      # "mobile_app"
      "modbus"
      # "modem_callerid"
      # "modern_forms"
      # "mold_indicator"
      "moon"
      # "motioneye"
      "mpd"
      "mqtt"
      "mqtt_eventstream"
      "mqtt_json"
      "mqtt_room"
      "mqtt_statestream"
      "my"
      "myq"
      "mysensors"
      # "mythicbeastsdns"
      # "myuplink"
      # "namecheapdns"
      "netdata"
      "netio"
      "network"
      # "nextdns"
      "nmap_tracker"
      # "no_ip"
      # "noaa_tides"
      "notify"
      "notify_events"
      "number"
      "nut"
      "nws"
      "oem"
      "ollama"
      "onboarding"
      "onewire"
      "onvif"
      "open_meteo"
      "openevse"
      # "opengarage"
      "openhardwaremonitor"
      "openhome"
      "opensensemap"
      "opensky"
      "openuv"
      "openweathermap"
      "opnsense"
      "opower"
      "osramlightify"
      "otp"
      "panel_custom"
      "persistent_notification"
      "person"
      "pi_hole"
      "picotts"
      # "pilight"
      # "pinecil"
      "ping"
      "plant"
      # "plex"
      "plugwise"
      "point"
      "powerwall"
      "private_ble_device"
      "profiler"
      "proximity"
      # "proxmoxve"
      "proxy"
      # "prusalink"
      # "ps4"
      "pulseaudio_loopback"
      "push"
      # "pushbullet"
      # "pvoutput"
      # "pvpc_hourly_pricing"
      "pyload"
      "python_script"
      # "qbittorrent"
      "qrcode"
      "random"
      # "raspberry_pi"
      # "raspyrfm"
      "recorder"
      "recovery_mode"
      # "remote"
      # "remote_rpi_gpio"
      "rest"
      "rest_command"
      # "rflink"
      # "rfxtrx"
      # "rhasspy"
      # "rpi_camera"
      # "rpi_power"
      # "rss_feed_template"
      # "rtorrent"
      # "rtsp_to_webrtc"
      "scene"
      "schedule"
      "scrape"
      "script"
      "search"
      "season"
      "select"
      # "sendgrid"
      "sensor"
      "serial"
      "serial_pm"
      "seven_segments"
      "shell_command"
      # "sigfox"
      # "sighthound"
      # "signal_messenger"
      "simulated"
      "siren"
      "sms"
      "smtp"
      "snmp"
      "speedtestdotnet"
      # "spider"
      # "starlink"
      "statistics"
      "statsd"
      "steam_online"
      "stream"
      "stt"
      "sun"
      "switch"
      "switch_as_x"
      # "switchbee"
      # "switchbot"
      # "switcher_kis"
      # "switchmate"
      # "syncthing"
      "syslog"
      "system_health"
      "system_log"
      "systemmonitor"
      "tag"
      "tailscale"
      "tailwind"
      "tcp"
      "telnet"
      "temper"
      "template"
      # "tensorflow"
      "text"
      "threshold"
      "time"
      "time_date"
      "timer"
      "tod"
      "todo"
      "tplink"
      "trace"
      "transmission"
      "trend"
      "triggercmd"
      "tts"
      "ubus"
      "unifi"
      "unifi_direct"
      "unifiled"
      "unifiprotect"
      "universal"
      "update"
      "upnp"
      "uptime"
      "uptimerobot"
      "usb"
      "usgs_earthquakes_feed"
      "utility_meter"
      "vacuum"
      "valve"
      "version"
      "vlc"
      "vlc_telnet"
      "wake_on_lan"
      "wake_word"
      "waqi"
      "water_heater"
      "watson_iot"
      "watttime"
      "waze_travel_time"
      "weather"
      "webhook"
      "webmin"
      "websocket_api"
      "whisper"
      "whois"
      "wiffi"
      "wilight"
      "wirelesstag"
      "wiz"
      "wled"
      "workday"
      "worldclock"
      "worldtidesinfo"
      "worxlandroid"
      "youtube"
      "zeroconf"
      "zodiac"
      "zone"
    ];
  };
  # systemd.services.home-assistant.preStart = ''
  #   ${pkgs.nix}/bin/nix eval --raw -f ${config.sops.secrets."services/bn-smarthome/hass-mqtt-yaml.nix".path} yaml > /var/lib/hass/mqtt.yaml
  # '';
  services.nginx.enable = true;
  services.nginx.virtualHosts."fatso.destinesia.xyz" = {
    forceSSL = true;
    enableACME = true;
    extraConfig = ''
      proxy_buffering off;
    '';
    locations."/" = {
      proxyPass = "http://[::1]:8123";
      proxyWebsockets = true;
    };
  };

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

  nix.settings.trusted-users = [ "root" "coldelectrons" "nix-ssh" ];

  plusultra = {
    nix = enabled;
    archetypes = {
      server = enabled;
    };
    cli-apps = {
      extras = enabled;
    };
    security = {
      acme = enabled;
      gpg = enabled;
    };
    apps = {
    };
    hardware = {
    };
    services = {
    };
    system = {
    };

    user.extraGroups = [ 
      "networkmanager"
      "wheel"
      "input"
      "plugdev"
      "dialout"
      "video"
      "audio"
      "libvirtd"
      "scanner"
      "i2c"
      "git"
    ];
  };

  users.users.coldelectrons = {
    extraGroups = [ "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNLc53xO8V/nzz1ebEGRplW0AeWhTUcYB1ZuWlRYDV1"
    ];
  };
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNLc53xO8V/nzz1ebEGRplW0AeWhTUcYB1ZuWlRYDV1"
    ];
  };

  # WiFi is typically unused on the desktop. Enable this service
  # if it's no longer only using a wired connection.
  # systemd.services.network-addresses-wlp41s0.enable = false;

  # something is making me wait 120 seconds, and I *hate* it
  systemd.network.wait-online.timeout = 0;
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.timeout = 0;
  boot.initrd.systemd.network.wait-online.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
