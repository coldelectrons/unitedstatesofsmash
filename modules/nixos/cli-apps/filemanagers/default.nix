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
  cfg = config.${namespace}.cli-apps.filemanagers;
in
{
  options.${namespace}.cli-apps.filemanagers = with types; {
    enable = mkBoolOpt false "Whether or not to enable command-line filemanagers.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # terminal file managers, because while I like mc
      # it doesn't seem to work right with fish or zsh
      mc
      lf
      walk
      fm-go
      joshuto
      superfile
      sfm
    ];
    programs.yazi = {
      enable = true;
    };
  };
}
