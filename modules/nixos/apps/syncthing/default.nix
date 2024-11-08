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
  stcfg = config.services.syncthing;
  user = config.${namespace}.user.name;

in
{
  options.${namespace}.apps.syncthing = with types; {
    enable = mkBoolOpt false "Whether or not to enable syncthing.";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      user = lib.mkForce user;
      enable = true;
      # dataDir = "/home/${cfg.services.syncthing.user}/Sync";
      dataDir = "/home/${user}/Sync";
      group = "users";
      # configDir = "/home/${stcfg.services.syncthing.user}/.config/syncthing";
      configDir = "/home/${user}/.config/syncthing";
      openDefaultPorts = true;
    };

    environment.systemPackages = with pkgs; [ syncthingtray-minimal ];
  };
}
