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
  cfg = config.${namespace}.apps.paperless;
in
{
  options.${namespace}.apps.paperless = with types; {
    enable = mkBoolOpt false "Whether or not to enable paperless.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ paperless ];
  };
}
