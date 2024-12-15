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
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        steamtinkerlaunch
      ];
      extraPackages = with pkgs; [
        firefox # needed for some games that oauth/connect with website
        mangohud
        gamescope
        gamemode
      ];
      extest.enable = true;
      protontricks.enable = true;
    };

    hardware.steam-hardware.enable = true;

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
