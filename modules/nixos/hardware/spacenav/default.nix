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
  cfg = config.${namespace}.hardware.spacenav;
in
{
  options.${namespace}.hardware.spacenav = with types; {
    enable = mkBoolOpt false "Whether to enable the 3Dconnexion Spacenav support.";
  };

  config = mkIf cfg.enable {
    # TODO XXX WTF current problems with spacenavd
    # * it runs as a systemd user unit
    #   * this wouldn't normally be a problem BUT
    #     * the nixpkg ties it to 'graphical.target', which isn't a user target
    #       It should be 'graphical-session.target'
    #       20241226 Now the default service unit depends on 'After=syslog'
    #       which is depreciated.
    #       So I made my own systemd user unit
    #     * spacenavd doesn't have read permissions for ANYTHING in /dev/input/
    #       by default, because users don't
    #       So I added some udev extraRules, and added myself to group input
    #   * I'm currently using a Wayland, so there might still need to be a
    #     workaround for xauth or whatever
    plusultra.user.extraGroups = [ "input" ];

    environment.systemPackages = with pkgs; [
      spacenavd
      spacenav-cube-example
    ];

    # currently, does nothing because the nixpkg makes the systemd
    # unit depend on graphical.target, which doesn't exist for user units
    # FIXME trying this out in 24.11 20241225
    # F*%#ME 20241226 still not working
    #   The unit _exists_, but it isn't enabled or doesn't start automatically
    # hardware.spacenavd.enable = true;
    
    # FIXME 20250103
    # So, this unit starts, but it's trying to create `/var/run/spnav.sock`, which
    # it doesn't have permissions to do, becuase it's a user unit.
    # systemd.user.services.spacenavd-user = {
    #   description = "Daemon for the Spacenavigator 6DOF mice by 3Dconnexion";
    #   wantedBy = ["graphical-session.target"];
    #   serviceConfig = {
    #     PIDFile="/var/run/user/1000/spnavd.pid"
    #     ExecStart = "${pkgs.spacenavd}/bin/spacenavd -d -v -l syslog";
    #   };
    # };

    # FIXME 20250103
    systemd.services."spacenavd" = {
      description = "Daemon for the Spacenavigator 6DOF mice by 3Dconnexion";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        PIDFile="/var/run/spnavd.pid";
        ExecStart = "${pkgs.spacenavd}/bin/spacenavd -d -v -l syslog";
      };
    };

    services.udev.packages = with pkgs; [ plusultra.spacenav-usb-udev-rules ];

  };
}
