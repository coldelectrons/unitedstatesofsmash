{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.tagstudio;
in
{
  options.${namespace}.apps.tagstudio = {
    enable = mkEnableOption "Enable TagStudio";
  };

  config = mkIf cfg.enable rec {
    home = {
      packages = with pkgs; [
        inputs.tagstudio.packages.${pkgs.stdenv.hostPlatform.system}.tagstudio
      ];
}

