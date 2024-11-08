inputs@{
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
  cfg = config.${namespace}.cli-apps.gurk-rs;
in
{
  options.${namespace}.cli-apps.gurk-rs = with types; {
    enable = mkBoolOpt false "Whether or not to enable gurk-rs, a cli signal client.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # gurk is too old in 24.05, use overlay
      gurk-rs
    ];
  };
}
