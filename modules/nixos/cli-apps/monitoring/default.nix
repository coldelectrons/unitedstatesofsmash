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
  cfg = config.${namespace}.cli-apps.monitoring;
in
{
  options.${namespace}.cli-apps.monitoring = with types; {
    enable = mkBoolOpt false "Whether or not to enable command-line extras for TODO sort this out.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      entr # run commands when files change!
      ncdu # TUI disk usage
      libnotify
      hwinfo
      hw-probe
      cyme # a better lsusb
      usbview
      clinfo
      pciutils
    ];
  };
}
