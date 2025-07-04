{
  options,
  config,
  pkgs,
  lib,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.vr;
  user = config.${namespace}.user;
  home = config.users.users.${user.name}.home;
  systemctl = getExe' pkgs.systemd "systemctl";
  lighthouse = getExe pkgs.lighthouse-steamvr;
  userHome = config.${namespace}.user.user.home;
  # TODO make modules for this
  defaultSink = "alsa_output.pci-0000_13_00.4.analog-stereo";
  defaultSource = "alsa_input.pci-0000_13_00.4.analog-stereo";
in
{
  options.${namespace}.hardware.vr = with types; {
    enable = mkBoolOpt false "Whether or not to enable VR/XR support.";
    monadoDefaultEnable = mkBoolOpt false "Whether or not to enable Monado as the default XR runtime.";
    valve-index = {
      enable = mkBoolOpt false "Whether or not to enable Valve Index XR/VR support.";
      audio = {
        card = mkOption {
          type = types.nullOr types.str;
          description = "Name of the Index audio card from `pact list cards`";
        };
        profile = mkOption {
          type = types.nullOr types.str;
          description = "Name of the Index audio profile from `pactl list cards`";
        };
        source = mkOption {
          type = types.nullOr types.str;
          description = "Name of the Index source device from `pactl list short sources`";
        };
        sink = mkOption {
          type = types.nullOr types.str;
          description = "Name of the Index sink device from `pactl list short sinks`";
        };
      };
    };
  };

  config = mkIf cfg.enable {

    system.activationScripts = {
      # TODO is this necessary when using Monado? I suppose it can't hurt
      # Fixes issue with SteamVR not starting
      fixSteamVR = "${pkgs.libcap}/bin/setcap CAP_SYS_NICE+ep ${home}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
    };

    programs.nix-ld.enable = true;
    # programs.nix-ld.libraries = with pkgs; [
    #   # the defaults, because I'm not certain how to add or append TODO FIXME
    #   zlib
    #   zstd
    #   stdenv.cc.cc
    #   curl
    #   openssl
    #   attr
    #   libssh
    #   bzip2
    #   libxml2
    #   acl
    #   libsodium
    #   util-linux
    #   xz
    #   systemd
    #   # additional
    #   bash
    #   openvr
    #   firefox
    #   steam
    #   steam-run
    #   monado
    #   opencomposite
    #   libuuid 
    # ];

    services.udev.packages = with pkgs; [
      # xr-hardware
      plusultra.nofio-usb-udev-rules
    ];

    # hardware.alsa.cardAliases = mkIf cfg.valve-index.enable {
    #   valve-index = {};
    #   # ${cfg.valve-index.audio.source} = "Valve Index";
    #   # ${cfg.valve-index.audio.sink} = "Valve Index";
    # };

    services.monado = {
      package = inputs.nixpkgs-xr.packages.${pkgs.system}.monado;
      enable = true;
      defaultRuntime = cfg.monadoDefaultEnable;
      highPriority = true;
    };

    systemd.user.services.monado = 
    {
      requires = [ "valve-index.service" ];
      after = [ "valve-index.service" ];
      serviceConfig = {
        ExecStartPre = "-${pkgs.writeShellScript "monado-exec-start-pre" ''
          rm -rf  "$XDG_CONFIG_HOME/openxr/1/active_runtime.json"
          ln -sf  "$XDG_CONFIG_HOME/openxr/1/active_runtime.json.monado" "$XDG_CONFIG_HOME/openxr/1/active_runtime.json"

          if [ ! -f "/tmp/disable-lighthouse-control" ]; then
            ${lighthouse} --state on
          fi
        ''}";

        ExecStopPost = "-${pkgs.writeShellScript "monado-exec-stop-post" ''
          rm -rf  "$XDG_CONFIG_HOME/openxr/1/active_runtime.json"
          ln -sf  "$XDG_CONFIG_HOME/openxr/1/active_runtime.json.steamvr" "$XDG_CONFIG_HOME/openxr/1/active_runtime.json"

          if [ ! -f "/tmp/disable-lighthouse-control" ]; then
            ${lighthouse} --state off
          fi
        ''}";
      };

      environment = {
        # Environment variable reference:
        # https://monado.freedesktop.org/getting-started.html#environment-variables

        # Using defaults from envision lighthouse profile:
        # https://gitlab.com/gabmus/envision/-/blob/main/src/profiles/lighthouse.rs

        XRT_COMPOSITOR_SCALE_PERCENTAGE = "180"; # super sampling of monado runtime
        XRT_COMPOSITOR_COMPUTE = "1";
        # These two enable a window that contains debug info and a mirror view
        # which monado calls a "peek window"
        XRT_DEBUG_GUI = "1";
        XRT_CURATED_GUI = "1";
        # Description I can't find the source of: Set to 1 to unlimit the
        # compositor refresh from a power of two of your HMD refresh, typically
        # provides a large performance boost
        # https://gitlab.freedesktop.org/monado/monado/-/merge_requests/2293
        U_PACING_APP_USE_MIN_FRAME_PERIOD = "1";

        # Display modes:
        # - 0: 2880x1600@90.00
        # - 1: 2880x1600@144.00
        # - 2: 2880x1600@120.02
        # - 3: 2880x1600@80.00
        XRT_COMPOSITOR_DESIRED_MODE = "0";

        # Use SteamVR tracking (requires calibration with SteamVR)
        STEAMVR_LH_ENABLE = "true";

        # Application launch vars:
        # SURVIVE_ vars are no longer needed
        # PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc for Steam applications

        # Modifies super sampling of the game. Multiplied by
        # XRT_COMPOSITOR_SCALE_PERCENTAGE so if XRT_COMPOSITOR_SCALE_PERCENTAGE
        # is 300 and OXR_VIEWPORT_SCALE_PERCENTAGE is 33, the game will render
        # at 100% and the monado runtime (wlx-s-overlay etc..) will render at
        # 300%
        # OXR_VIEWPORT_SCALE_PERCENTAGE=100;

        # If using Lact on an AMD GPU can set GAMEMODE_CUSTOM_ARGS=vr when using
        # gamemoderun command to automatically enable the VR power profile

        # TODO add some way of profiles in steamtinkerlaunch or something
        # Baseline launch options for Steam games:
        # PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc GAMEMODE_CUSTOM_ARGS=vr gamemoderun %command%
        STEAMVR_PATH = "${home}/.steam/root/steamapps/common/SteamVR";

        WMR_HANDTRACKING = "1";
        AMD_VULKAN_ICD = "RADV";
      };
    };

  # Fix for audio cutting out when GPU is under load
  # https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Troubleshooting#stuttering-audio-in-virtual-machine
  services.pipewire.wireplumber.extraConfig = mkMerge [
    {
      "99-valve-index"."monitor.alsa.rules" = singleton {
        matches = singleton {
          "node.name" = "${cfg.valve-index.audio.sink}";
        };
        actions.update-props = {
          # This adds latency so set to minimum value that fixes problem
          "api.alsa.period-size" = 1024;
          "api.alsa.headroom" = 8192;
        };
      };
    }
    (mkIf (cfg.valve-index.enable) {
      "99-alsa-device-aliases"."monitor.alsa.rules" = mkMerge [
        {
          matches = singleton {
            "node.name" = "${cfg.valve-index.audio.source}";
          };
          actions.update-props."node.description" = "Valve Index";
        }
        {
          matches = singleton {
            "node.name" = "${cfg.valve-index.audio.sink}";
          };
          actions.update-props."node.description" = "Valve Index";
        }
      ];
    })
  ];

  systemd.user.services.valve-index =
    let
      pactl = getExe' pkgs.pulseaudio "pactl";
      sleep = getExe' pkgs.coreutils "sleep";
    in
    {
      description = "Valve Index";
      partOf = [ "monado.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          pkgs.writeShellScript "valve-index-start" # bash
            ''
              # Monado doesn't change audio devices so we have to do it
              # manually. SteamVR changes the default sink but doesn't set the
              # default source or the card profile.
              ${pactl} set-default-source "${cfg.valve-index.audio.source}"
              ${pactl} set-source-mute "${cfg.valve-index.audio.source}" 1
              ${pactl} set-card-profile "${cfg.valve-index.audio.card}" "${cfg.valve-index.audio.profile}"

              # The sink device can only bet set after the headset has powered on
              (${sleep} 10; ${pactl} set-default-sink "${cfg.valve-index.audio.sink}") &
            '';

        ExecStop =
          pkgs.writeShellScript "valve-index-stop" # bash
            ''
              ${pactl} set-default-source ${defaultSource}
              ${pactl} set-default-sink ${defaultSink}
            '';
      };
    };


    environment.sessionVariables = {
      # why is this necessary? which one is more correct?
      # LIBMONADO_PATH = "${config.services.monado.package}/lib/libmonado.so";
      LIBMONADO_PATH = "${pkgs.monado}/lib/libmonado.so";
      XR_RUNTIME_JSON = "$XDG_CONFIG_HOME/openxr/1/active_runtime.json";
      PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
    };

    programs.steam = {
      # extraCompatPackages = [
      #   # FIXME this causes 
      #   # The store path /nix/store/l7wmmarasbmxiz4xciv6bch0zwqmvvm4-proton-ge-rtsp-bin-GE-Proton9-20-rtsp16 is a file and can't be merged into an environment using pkgs.buildEnv!
      #   # so manually install it for now
      #   inputs.nixpkgs-xr.packages.${pkgs.system}.proton-ge-rtsp-bin # for resonite??
      # ];
      extraPackages = with pkgs; [
        # FIXME had a problem with steam and bluetooth, dunno if these helped
        hidapi
        monado
        opencomposite
        vkbasalt
        monado-vulkan-layers
      ];
    };

    hardware.graphics.extraPackages = with pkgs; [
      monado-vulkan-layers
    ];

    programs.envision = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      lighthouse-steamvr
      inputs.nixpkgs-xr.packages.${pkgs.system}.index_camera_passthrough
      monado-vulkan-layers
      wlx-overlay-s
      opencomposite
      libsurvive
      vkbasalt
      # motoc
      basalt-monado
      xrgears
      xrizer
      # xr-hardware
      corectrl
      gamemode
      openxr-loader
      libusb1

      (pkgs.makeDesktopItem {
        name = "start monado/steamvr";
        desktopName = "Start Monado/SteamVR";
        type = "Application";
        exec = getExe (writeShellScriptBin "start-monado-steamvr" ''
              rm -rf  "$XDG_CONFIG_HOME/openvr/openvrpaths.vrpath"
              ln -sf  "$XDG_CONFIG_HOME/openvr/openvrpaths.vrpath.steamvr" "$XDG_CONFIG_HOME/openvr/openvrpaths.vrpath"
              ${systemctl} start --user monado
            ''
          );
        icon = (
          pkgs.fetchurl {
            url = "https://gitlab.freedesktop.org/uploads/-/system/group/avatar/5604/monado_icon_medium.png";
            hash = "sha256-Wx4BBHjNyuboDVQt8yV0tKQNDny4EDwRBtMSk9XHNVA=";
          }
        );
        categories = [ "Game" "X-VR" ];
      })
      (pkgs.makeDesktopItem {
        name = "stop monado";
        desktopName = "Stop Monado";
        type = "Application";
        exec = getExe (writeShellScriptBin "stop-monado" ''
              ${systemctl} stop --user monado
              rm -rf  "$XDG_CONFIG_HOME/openvr/openvrpaths.vrpath"
              ln -sf  "$XDG_CONFIG_HOME/openvr/openvrpaths.vrpath.steamvr" "$XDG_CONFIG_HOME/openvr/openvrpaths.vrpath"
            ''
          );
        icon = (
          pkgs.fetchurl {
            url = "https://gitlab.freedesktop.org/uploads/-/system/group/avatar/5604/monado_icon_medium.png";
            hash = "sha256-Wx4BBHjNyuboDVQt8yV0tKQNDny4EDwRBtMSk9XHNVA=";
          }
        );
        categories = [ "Game" "X-VR" ];
      })
      (pkgs.makeDesktopItem {
        name = "start monado/opencomposite";
        desktopName = "Start Monado/Opencomposite";
        type = "Application";
        exec = getExe (writeShellScriptBin "start-monado-opencomposite" ''
              rm -rf  "$XDG_CONFIG_HOME/openvr/openvrpaths.vrpath"
              ln -sf  "$XDG_CONFIG_HOME/openvr/openvrpaths.vrpath.opencomposite" "$XDG_CONFIG_HOME/openvr/openvrpaths.vrpath"
              ${systemctl} start --user monado
            ''
          );
        icon = (
          pkgs.fetchurl {
            url = "https://gitlab.freedesktop.org/uploads/-/system/group/avatar/5604/monado_icon_medium.png";
            hash = "sha256-Wx4BBHjNyuboDVQt8yV0tKQNDny4EDwRBtMSk9XHNVA=";
          }
        );
        categories = [ "Game" "X-VR" ];
      })
      (pkgs.makeDesktopItem {
        name = "start-vr";
        desktopName = "Start VR";
        type = "Application";
        exec = "${systemctl} start --user valve-index";
        icon = "applications-system";
        categories = [ "Game" "X-VR" ];
      })
      (pkgs.makeDesktopItem {
        name = "stop-vr";
        desktopName = "Stop VR";
        type = "Application";
        exec = "${systemctl} stop --user valve-index";
        icon = "applications-system";
        categories = [ "Game" "X-VR" ];
      })
      (pkgs.makeDesktopItem {
        name = "wlx-overlay";
        desktopName = "WLX Overlay";
        genericName = "WLX Overlay for SteamVR";
        exec = "${pkgs.wlx-overlay-s}/bin/wlx-overlay-s --replace";
        icon = ./wlx-overlay-s.png;
        type = "Application";
        categories = [ "Game" "X-VR" ];
        terminal = false;
      })
    ];

    
  };
}
