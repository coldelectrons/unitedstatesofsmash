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
  cfg = config.${namespace}.apps.btrfs;
in
{
  options.${namespace}.apps.ardour = with types; {
    enable = mkBoolOpt false "Whether or not to enable btrfs gui tools.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      buttermanager
      btrfs-assistant
      timeshift
      snapper-gui
    ];
  };
}
