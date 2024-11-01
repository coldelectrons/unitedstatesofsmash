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
  cfg = config.${namespace}.apps.bitscope;
in
{
  options.${namespace}.apps.bitscope = with types; {
    enable = mkBoolOpt false "Whether or not to enable bitscope.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bitscope.dso
      bitscope.server
      bitscope.proto
      bitscope.logic
      bitscope.meter
      bitscope.display
      bitscope.console
      bitscope.chart
    ];
  };
}
