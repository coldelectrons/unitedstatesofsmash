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
          enable = lib.mkForce true;
          efiSupport = true;
          device = "nodev";
          memtest86.enable = true;
        };
        systemd-boot = {
          enable = false;
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
