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
    services.system-config-printer.enable = true;
    services.printing.webInterface = true;
    services.printing.cups-pdf.enable = true;
    hardware.sane.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    environment.systemPackages = with pkgs; [ hplipWithPlugin gutenprint foomatic-db ];
    hardware.printers = {
      ensurePrinters = [
        {
          name = "HP-LaserJet";
          location = "Home";
          deviceUri = "usb://HP/LaserJet%20Professional%20P1102w?serial=000000000W403SNSPR1a";
          model = "HP/hp-laserjet_professional_p_1102w.ppd.gz";
        }
      ];
    };
    services.printing = { 
      enable = true;
      drivers = with pkgs; [ hplipWithPlugin ];
    };
  };
}
