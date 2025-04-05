{
  lib,
  pkgs,
  config,
  osConfig ? { },
  format ? "unknown",
  namespace,
  ...
}:
with lib.${namespace};
{
  plusultra = {
    user = {
      enable = true;
      name = "sandwitch";
      email = "frithomas@gmail.com"; # TODO put this into secrets
      # home = "/home/coldelectrons";
    };

    cli-apps = {
      zsh = enabled;
      atuin = enabled;
      lunarvim = enabled;
      home-manager = enabled;
      # yubikey = enabled // {
      #   identifiers = {
      #     maci = 27174342;
      #     manu = 30766267;
      #   };
      # };
    };

    tools = {
      git = enabled // {
        userEmail = "frithomas@gmail.com";
        userName = "coldelectrons";
      };
      direnv = enabled;
      # yubikeyTouchDetector = enabled;
    };
  };

  home.sessionPath = [ "$HOME/bin" ];

   home.sessionVariables = {
    EDITOR = "lvim";
    TERM = "kitty";

    # Wayland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "plasma";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  home.stateVersion = "24.05";
}
