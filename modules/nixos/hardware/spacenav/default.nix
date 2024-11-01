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
    # unit depend on graphical.target, which doesn't exist for users
    # hardware.spacenavd.enable = true;

    systemd.user.services.spacenavd-user = {
      description = "Daemon for the Spacenavigator 6DOF mice by 3Dconnexion";
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.spacenavd}/bin/spacenavd -d -l syslog";
      };
    };

    # because this is supposed to be a USER unit, and the default permissions are 660
    services.udev.extraRules = ''
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c605", MODE="0666", GROUP="input", SYMLINK+="input/cadman", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c606", MODE="0666", GROUP="input", SYMLINK+="input/spacemouse_classic", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c621", MODE="0666", GROUP="input", SYMLINK+="input/spaceball5000", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c623", MODE="0666", GROUP="input", SYMLINK+="input/spacetraveler", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c625", MODE="0666", GROUP="input", SYMLINK+="input/spacepilot", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c626", MODE="0666", GROUP="input", SYMLINK+="input/spacenavigator", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c627", MODE="0666", GROUP="input", SYMLINK+="input/spaceexplorer", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c628", MODE="0666", GROUP="input", SYMLINK+="input/spacenavigator_notebooks", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c629", MODE="0666", GROUP="input", SYMLINK+="input/spacepilot_pro", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c62b", MODE="0666", GROUP="input", SYMLINK+="input/spacemouse_pro", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c603", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c605", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c606", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c621", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c623", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c625", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c626", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c627", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c628", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c629", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c62b", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c62e", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c62f", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c631", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c632", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c633", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c635", MODE="0666", GROUP="input", SYMLINK+="input/spacemouse_compact", SYMLINK+="input/3dconnexion"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c636", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c640", MODE="0666", GROUP="input"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c652", MODE="0666", GROUP="input"
    '';
  };
}
