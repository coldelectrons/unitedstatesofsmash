{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.addons.signal;

  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.${namespace}.desktop.addons.signal = {
    enable = mkEnableOption "signal desktop messaging";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ signal-desktop ]; };
  # TODO add gurk-rs, but that needs an overlay for unstable version
}
