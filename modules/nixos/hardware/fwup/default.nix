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
  cfg = config.${namespace}.hardware.fimware-update;
in
{
  options.${namespace}.hardware.fimware-update = with types; {
    enable = mkBoolOpt false "Whether or not to enable graphics support";
  };

  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
