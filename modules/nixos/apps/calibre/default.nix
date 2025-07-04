{
  options,
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.calibre;
in
{
  options.${namespace}.apps.calibre = with types; {
    enable = mkBoolOpt false "Whether or not to enable calibre.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      calibre
      plusultra.dedrm
    ];
  };
}

