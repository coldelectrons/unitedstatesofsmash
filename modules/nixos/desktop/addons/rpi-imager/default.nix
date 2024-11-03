{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.addons.rpi-imager;

  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.${namespace}.desktop.addons.rpi-imager = {
    enable = mkEnableOption "rpi-imager";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ rpi-imager ]; };
}
