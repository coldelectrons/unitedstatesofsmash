{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.printing;
in
{
  options.${namespace}.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing/scanning support.";
  };

  config = mkIf cfg.enable { 
    services.printing.enable = true; 
    services.system-config-printer.enable = true;
    services.printing.webInterface = true;
    services.printing.cups-pdf.enable = true;
    hardware.sane.enable = true;
  };
}
