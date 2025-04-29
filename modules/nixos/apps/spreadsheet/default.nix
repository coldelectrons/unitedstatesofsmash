{
  options,
  config,
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.spreadsheet;
in
{
  options.${namespace}.apps.spreadsheet = with types; {
    enable = mkBoolOpt false "Whether or not to enable spreadsheet apps.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
      onlyoffice-desktopeditors
      gnumeric
      pyspread
    ];
  };
}

