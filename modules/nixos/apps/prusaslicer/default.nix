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
  cfg = config.${namespace}.apps.prusaslicer;
in
{
  options.${namespace}.apps.prusaslicer = with types; {
    enable = mkBoolOpt false "Whether or not to enable prusaslicer.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ prusa-slicer ]; };
}
