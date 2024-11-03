{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.addons.sirikali;

  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.${namespace}.desktop.addons.sirikali = {
    enable = mkEnableOption "Sirikali encrypted-fs manager";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ sirikali ]; };
}
