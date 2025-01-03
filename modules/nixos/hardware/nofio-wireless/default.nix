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
      plusultra.virtualhere
    ];

    #TODO add systemd service unit and config
  };
}
