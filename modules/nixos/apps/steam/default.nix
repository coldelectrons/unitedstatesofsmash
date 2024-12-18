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
  cfg = config.${namespace}.apps.steam;
  user = config.${namespace}.user.name;
in
{
  options.${namespace}.apps.steam = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for Steam.";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.remotePlay.openFirewall = true;
    programs.steam.extraPackages = with pkgs; [
      firefox
      mangohud
      gamescope
      gamemode
    ];

    hardware.steam-hardware.enable = true;

    # Fixes issue with SteamVR not starting
    system.activationScripts = {
      fixSteamVR =
        "${pkgs.libcap}/bin/setcap CAP_SYS_NICE+ep /home/${user}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
    };
    # Enable GameCube controller support.
    services.udev.packages = [ pkgs.dolphin-emu ];

    environment.systemPackages = with pkgs; [
      plusultra.steam # add desktop items
      steam-run
      # steamcontroller
      sc-controller
      protonup
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
  };
}
