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
  cfg = config.${namespace}.apps.mpd;
in
{
  options.${namespace}.apps.mpd = with types; {
    enable = mkBoolOpt false "Whether or not to enable mpd.";
  };

  config = mkIf cfg.enable {
  environment.systemPackages = with pkgs; [
      mpd
      mpd-sima
      ashuffle
      mus
      mpc-cli
      cantata
      pms
      ario
      ncmpcpp
      miniplayer
      sonata
    ];
  };
}
