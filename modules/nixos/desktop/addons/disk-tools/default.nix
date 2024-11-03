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

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ sirikali gparted exfatprogs fatresize util-linux partition-manager dosfstools ]; };
}
