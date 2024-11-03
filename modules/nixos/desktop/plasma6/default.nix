{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.plasma6;
  user = config.${namespace}.user;
  kdeHome = config.users.users.${user.name}.home;


  default-attrs = mapAttrs (key: mkDefault);
  nested-default-attrs = mapAttrs (key: default-attrs);
in
{
  options.${namespace}.desktop.plasma6 = with types; {
    enable = mkBoolOpt false "Whether or not to use plasma6 as the desktop environment.";
    color-scheme = mkOpt (enum [
      "light"
      "dark"
    ]) "dark" "The color scheme to use.";
    wayland = mkBoolOpt true "Whether or not to use Wayland.";
    suspend = mkBoolOpt true "Whether or not to suspend the machine after inactivity.";
    monitors = mkOpt (nullOr path) null "The monitors.xml file to create.";
    extensions = mkOpt (listOf package) [ ] "Extra plasma extensions to install.";
  };

  config = mkIf cfg.enable {
    plusultra.system.xkb.enable = true;
    plusultra.desktop.addons = {
      gtk = enabled;
      # wallpapers = enabled;
      electron-support = enabled;
      kitty = enabled;
      bitwarden = enabled;
      clipboard = enabled;
      disk-tools = enabled;
      rpi-imager = enabled;
      signal = enabled;
      xdg-portal = enabled;
    };

    plusultra.hardware  = {
      audio = enabled;
      spacenav = enabled;
      storage = enabled;
    };

    environment.systemPackages =
      with pkgs;
      [
        (hiPrio plusultra.xdg-open-with-portal)
        wl-clipboard
        kdePackages.plasma-vault
        kdePackages.plasma-disks
        krename
        qalculate-qt
        kdiskmark
        # Libraries/Utilities
        clinfo # for kinfocenter for OpenCL page
        glxinfo # for kinfocenter for OpenGL EGL and GLX page
        vulkan-tools # for kinfocenter for Vulkan page
        gpu-info
        wayland-utils # for kinfocenter for Wayland page
        ffmpegthumbnailer # for video thumbnails
        linuxquota # for plasma-disks
        ktorrent
        kfind
        filelight
        skanpage # Scanner
        kdePackages.print-manager
        # plasma-welcome # Welcome screen

        # Libraries/Utilities
        kdePackages.kdegraphics-thumbnailers
        ffmpegthumbs
        xwaylandvideobridge
        kdePackages.qtwayland
        strawberry-qt6
        # TODO move this to app module
        kdePackages.skanlite
        paperwork
        gscan2pdf
        unpaper
        noteshrink
        deskew
        paperless-ngx
        sane-frontends
        ocrmypdf
        brscan5
        brscan4
        xsane

      ]
      # ++ defaultExtensions
      ++ cfg.extensions;

    environment.plasma6.excludePackages = with pkgs; [
      # kdePackages.elisa
    ];

    # TODO is this even necessary
    # Create system services for KDE connect
    # systemd.user.services.kdeconnect = {
    #   description = "Adds communication between your desktop and your smartphone";
    #   after = [ "graphical-session-pre.target" ];
    #   partOf = [ "graphical-session.target" ];
    #   wantedBy = [ "graphical-session.target" ];

    #   serviceConfig = {
    #     #Environment = "PATH=${config.home.profileDirectory}/bin";
    #     ExecStart = "${kdeconnect-pkg}/libexec/kdeconnectd";
    #     Restart = "on-abort";
    #   };
    # };
    # TODO is this even necessary
    # systemd.tmpfiles.rules =
    #   [ "d ${kdeHome}/.config 0711 sddm sddm" ]
    #   ++ (
    #     # "./monitors.xml" comes from ~/.config/monitors.xml when plasma
    #     # display information is updated.
    #     lib.optional (cfg.monitors != null) "L+ ${kdeHome}/.config/monitors.xml - - - - ${cfg.monitors}"
    #   );

    systemd.services.plusultra-user-icon = {
      before = [ "display-manager.service" ];
      wantedBy = [ "display-manager.service" ];

      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";
      };

      script = ''
        config_file=/var/lib/AccountsService/users/${config.${namespace}.user.name}
        icon_file=/run/current-system/sw/share/plusultra-icons/user/${config.${namespace}.user.name}/${
          config.${namespace}.user.icon.fileName
        }

        if ! [ -d "$(dirname "$config_file")"]; then
          mkdir -p "$(dirname "$config_file")"
        fi

        if ! [ -f "$config_file" ]; then
          echo "[User]
          Session=plasma6
          SystemAccount=false
          Icon=$icon_file" > "$config_file"
        else
          icon_config=$(sed -E -n -e "/Icon=.*/p" $config_file)

          if [[ "$icon_config" == "" ]]; then
            echo "Icon=$icon_file" >> $config_file
          else
            sed -E -i -e "s#^Icon=.*$#Icon=$icon_file#" $config_file
          fi
        fi
      '';
    };

    # Required for app indicators
    services.udev.packages = with pkgs; [ solaar ];

    services.libinput.enable = true;

    # Hint electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services = {
      xserver.enable = true;

      displayManager.sddm = {
        enable = true;
        wayland.enable = cfg.wayland;
        # autoSuspend = cfg.suspend;
      };
      desktopManager.plasma6.enable = true;
      desktopManager.plasma6.enableQt5Integration = true;
    };

    plusultra.home.extraOptions = {
    };

    programs.kdeconnect = {
      enable = true;
    };

    # TODO Is this even necessary
    # TODO and isn't there a more Nix-y way to do this
    # Open firewall for samba connections to work.
    # networking.firewall.extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
    services.samba.openFirewall = true;
    services.samba.enable = true;
    

  };
}
