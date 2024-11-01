{
  options,
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.discord;
in
{
  options.${namespace}.apps.discord = with types; {
    enable = mkBoolOpt false "Whether or not to enable Discord.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.discord ];
  };
}
