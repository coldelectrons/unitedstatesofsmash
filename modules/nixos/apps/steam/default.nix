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
      gamescopeSession.enable = true;
      remotePlay.openFirewall = false;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        vkd3d-proton
        steam-play-none
      ];
      extraPackages = with pkgs; [
        firefox # needed for some non-steam games that oauth/connect with website
        xorg.libXcursor
        xorg.libxcb 
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamemode
        dxvk_2
        gamescope
        mangohud
        SDL2
        libjpeg
        openal
        libglvnd
        gtk3
        mono
        simpleDBus
      ];
      # extest.enable = true;
      protontricks.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # plusultra.steam # add desktop items
      steam-run
      steamcmd
      steam-tui
      steamcontroller
      sc-controller
      protonup
      protonup-qt
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
  };
}
