{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.usbipd;

  device = types.submodule {
    options = {
      productid = mkOption types.str;
      vendorid = mkOption types.str;
    };
  };
in
{
  options.${namespace}.services.usbipd = {
    enable = mkEnableOption "usbipd server";
    kernelPackage = mkOption {
      type = types.package;
      default = config.boot.kernelPackage.usbip;
      description = "The kernel module package to install";
    };
    devices = mkOption {
      type = types.listOf device;
      default = [];
      description = "List of USB devices to watch and automatically export.";
    };
    example = {
      productid = "xxxx";
      vendorid = "xxxx";
    };
    openFirewall = mkEnableOption "Open port 3240 for usbipd";
  };

  config = mkIf cfg.enable {
    boot.extraModulesPackages = [ cfg.kernelPackage ];
    boot.kernelModules = [ "usbip-core" "usbip-host" ];
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 3240 ];
    services.udev.extraRules = strings.concatLines
     ((map (dev: 
        "ACTION==\"add\", SUBSYSTEM==\"usb\", ATTRS{idProduct}==\"${dev.productid}\", ATTRS{idVendor}==\"${dev.vendorid}\", RUN+=\"${pkgs.systemd}/bin/systemctl restart usbip-${dev.vendorid}:${dev.productid}.service\"") cfg.devices));

    systemd.services = (builtins.listToAttrs (map (dev: { name = "usbip-${dev.vendorid}:${dev.productid}"; value = {
        after = [ "usbipd.service" ];
        script = ''
          set +e
          devices=$(${cfg.kernelPackage}/bin/usbip list -l | grep -E "^.*- busid.*(${dev.vendorid}:${dev.productid})" )
          output=$(${cfg.kernelPackage}/bin/usbip -d bind -b $(echo $devices | ${pkgs.gawk}/bin/awk '{ print $3 }') 2>&1)
          code=$?


          echo $output
          if [[ $output =~ "already bound" ]]; then
            exit 0
          else
            exit $code
          fi
        '';
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        restartTriggers = [ "usbipd.service" ];
      };
      }) cfg.devices)) // {
        usbipd = {
          wantedBy = [ "multi-user.target" ];
          serviceConfig.ExecStart = "${cfg.kernelPackage}/bin/usbipd -D";
          serviceConfig.Type = "forking";
        };
      };
  };
}
