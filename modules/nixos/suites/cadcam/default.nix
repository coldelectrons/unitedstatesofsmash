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
  cfg = config.${namespace}.suites.cadcam;
in
{
  options.${namespace}.suites.cadcam = with types; {
    enable = mkBoolOpt false "Whether or not to enable CAD/CAM configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        inkscape = enabled;
        freecad = enabled;
        kicad = enabled;
        prusaslicer = enabled;
      };
    };
  };
}
