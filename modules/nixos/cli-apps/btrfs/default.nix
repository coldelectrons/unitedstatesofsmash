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
  cfg = config.${namespace}.cli-apps.btrfs;
in
{
  options.${namespace}.cli-apps.btrfs = with types; {
    enable = mkBoolOpt false "Whether or not to enable command-line btrfs tools.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btrfs-progs
      btrfs-snap
      btrfs-heatmap
      btrbk
    ];
  };
}
