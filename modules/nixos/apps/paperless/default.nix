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
  cfg = config.${namespace}.apps.paperless;
in
{
  options.${namespace}.apps.paperless = with types; {
    enable = mkBoolOpt false "Whether or not to enable paperless.";
  };

  config = mkIf cfg.enable {
    services.paperless.enable = true;
    services.paperless.settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_OCR_LANGUAGE = "eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
    services.paperless.consumptionDirIsPublic = true;
  };
}
