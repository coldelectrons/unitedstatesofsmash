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
  cfg = config.${namespace}.apps.rcu;
in
{
  options.${namespace}.apps.rcu = with types; {
    enable = mkBoolOpt false "Whether or not to enable rcu.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # plusultra.rcu-dev
      rcu
    ];
  };
}

