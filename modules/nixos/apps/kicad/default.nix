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
  cfg = config.${namespace}.apps.kicad;
in
{
  options.${namespace}.apps.kicad = with types; {
    enable = mkBoolOpt false "Whether or not to enable kicad.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kicad
      kikit
      kicadAddons.kikit
      kicadAddons.kikit-library
    ];
  };
}
