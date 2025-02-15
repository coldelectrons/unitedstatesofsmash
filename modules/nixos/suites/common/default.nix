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
  cfg = config.${namespace}.suites.common;
in
{
  # Common suite is a little fatter than slim, adding stuff intended for laptops/desktops
  options.${namespace}.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;[
      plusultra.list-iommu
      linux-firmware
    ];

    hardware.firmware = with pkgs; [ linux-firmware ];

    services.smartd.enable = true;
    services.irqbalance.enable = true;

    plusultra = {
      suites.common-slim = enabled;

      # TODO: Enable this once Attic is configured again.
      # cache.public = enabled;

      cli-apps = {
        filemanagers = enabled;
        btrfs = enabled;
        extras = enabled;
        kitty_extras = enabled;
        monitoring = enabled;
        networking = enabled;
      };

      tools = {
        appimage-run = enabled;
        misc = enabled;
        # nix-ld = enabled;
        bottom = enabled;
        direnv = enabled;
      };

      hardware = {
        audio = enabled;
        fwup = enabled;
      };

      services = {
        printing = enabled;
      };

      security = {
        gpg = enabled;
        keyring = enabled;
      };

      system = {
      };
    };

    security.polkit.enable = true;
  };
}
