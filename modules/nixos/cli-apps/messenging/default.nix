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
  cfg = config.${namespace}.cli-apps.messenging;
in
{
  options.${namespace}.cli-apps.messenging = with types; {
    enable = mkBoolOpt false "Whether or not to enable command-line Signal apps.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # signald
      # signal-export
      # scli
    ];
  };
}
