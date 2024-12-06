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
  cfg = config.${namespace}.system.boot;
in
{
  options.${namespace}.system.boot = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting.";
  };

  config = mkIf cfg.enable {
    boot = {
      # Bootloader
      loader = {
        grub = {
          enable = false;
          efiSupport = true;
          devices = [ "nodev" ];
          memtest86.enable = true;
        };
        systemd-boot = {
          enable = true;
          memtest86.enable = true;
          consoleMode = "max";
          graceful = true;
          configurationLimit = 5;
        };
        efi = {
          canTouchEfiVariables = true;
          # efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
        };
      };
    };
  };
}
