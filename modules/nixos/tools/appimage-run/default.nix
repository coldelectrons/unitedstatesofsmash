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
  cfg = config.${namespace}.tools.appimage-run;
in
{
  options.${namespace}.tools.appimage-run = with types; {
    enable = mkBoolOpt false "Whether or not to enable appimage-run.";
  };

  config = mkIf cfg.enable {

    programs.appimage = {
      enable = true;
      # package = pkgs.appimage-run.override {
      #   extraPkgs = with pkgs; [
      #     
      #   ];
      # };
    };
  };
}
