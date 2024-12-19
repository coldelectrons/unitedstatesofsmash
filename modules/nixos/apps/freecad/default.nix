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
  cfg = config.${namespace}.apps.freecad;
in
{
  options.${namespace}.apps.freecad = with types; {
    enable = mkBoolOpt false "Whether or not to enable FreeCAD.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ freecad-wayland ]; };
}
