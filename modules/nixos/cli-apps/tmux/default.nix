{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli-apps.tmux;
in
{
  options.${namespace}.cli-apps.tmux = {
    enable = mkEnableOption "Tmux";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # TODO see what the heck Jake did to jazz up his tmux
      # plusultra.tmux
      tmux
    ];
  };
}
