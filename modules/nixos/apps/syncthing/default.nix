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
  cfg = config.${namespace}.apps.syncthing;
in
{
  options.${namespace}.apps.syncthing = with types; {
    enable = mkBoolOpt false "Whether or not to enable syncthing.";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      user = lib.mkForce config.variables.username;
      enable = true;
      dataDir = "/home/${config.services.syncthing.user}/Sync";
      group = "users";
      configDir = "/home/${config.services.syncthing.user}/.config/syncthing";
      openDefaultPorts = true;
    };

    environment.systemPackages = with pkgs; [ syncthingtray-minimal ];
  };
}
