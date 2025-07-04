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
  cfg = config.${namespace}.suites.ereader;
in
{
  options.${namespace}.suites.ereader = with types; {
    enable = mkBoolOpt false "Whether or not to enable suite of ereader apps.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        rcu = enabled;
        calibre = enabled;
      };
    };
    environment.systemPackages = with pkgs; [
      koreader
    ];
  };
}

