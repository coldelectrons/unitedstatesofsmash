{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.addons.bitwarden;

  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.${namespace}.desktop.addons.bitwarden = {
    enable = mkEnableOption "Bitwarden password manager";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ bitwarden ]; };
}
