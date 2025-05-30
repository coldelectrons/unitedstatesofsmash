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
  cfg = config.${namespace}.suites.common-slim;
in
{
  # Common-slim is supposed to be a good base for headless servers and desktops
  options.${namespace}.suites.common-slim = with types; {
    enable = mkBoolOpt false "Whether or not to enable common-slim configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kitty.terminfo # TODO does this work?
      foot.terminfo
    ];

    plusultra = {
      nix = enabled;

      # TODO: Enable this once Attic is configured again.
      # cache.public = enabled;

      cli-apps = {
        flake = enabled;
        # thaw = enabled;
        btrfs = enabled;
      };

      tools = {
        git = enabled;
        fup-repl = enabled;
        comma = enabled;
        bottom = enabled;
      };

      hardware = {
        storage = enabled;
        networking = enabled;
      };

      services = {
        openssh = enabled;
        tailscale = enabled;
        avahi = enabled;
      };

      security = {
      };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
  };
}
