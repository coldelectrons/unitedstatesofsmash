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
  cfg = config.${namespace}.hardware.fwup;
in
{
  options.${namespace}.hardware.fwup = with types; {
    enable = mkBoolOpt false "Whether or not to enable the firmware update daemon";
  };

  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
