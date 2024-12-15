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
  cfg = config.${namespace}.archetypes.gaming;
in
{
  options.${namespace}.archetypes.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable the gaming archetype.";
  };

  config = mkIf cfg.enable {
    plusultra.suites = {
      common = enabled;
      desktop = enabled;
      games = enabled;
      social = enabled;
      media = enabled;
    };

    programs.gamemode.enable = true;

    boot.kernel.sysctl = {
      # SteamOS/Fedora default
      "vm.max_map_count" = 2147483642;

      # unknown if this is part of my threat model on a gaming desktop
      # I'd like the perfomance back in that case
      "kernel.split_lock_mitigate" = 0;
    };

  };
}
