{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.addons.disk-tools;

  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.${namespace}.desktop.addons.disk-tools = {
    enable = mkEnableOption "disk-tools";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # sirikali # 20250426 fails due to xmlrpc
      gparted
      exfatprogs
      fatresize
      util-linux
      kdePackages.partitionmanager
      dosfstools
      # ventoy-full # bootable USB solution, 2025-05 marked insecure
      usbimager
      rpi-imager
    ];
  };
}
