{
    # Snowfall Lib provides a customized `lib` instance with access to your flake's library
    # as well as the libraries available from your flake's inputs.
    lib,
    # An instance of `pkgs` with your overlays and packages applied is also available.
    pkgs,
    # You also have access to your flake's inputs.
    inputs,

    # Additional metadata is provided by Snowfall Lib.
    namespace, # The namespace used for your flake, defaulting to "internal" if not set.
    home, # The home architecture for this host (eg. `x86_64-linux`).
    target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
    format, # A normalized name for the home target (eg. `home`).
    # format ? "unknown",
    virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
    host, # The host name for this home.

    # All other arguments come from the home home.
    config,
    osConfig ? { },
    ...
}:
with lib.${namespace};
{
  plusultra = {
    user = {
      enable = true;
      name = "coldelectrons";
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

    apps.vr = enabled // {
      handTrackingModels = enabled;
    };
    apps.tagstudio = enabled;

    tools = {
      git = enabled // {
        userEmail = "frithomas@gmail.com";
        userName = "coldelectrons";
      };
      direnv = enabled;
      # yubikeyTouchDetector = enabled;
    };
  };

  home.packages = with pkgs; [
    pipx
    bash
  ];

  programs.gallery-dl = {
    enable = true;
    settings = {
      extractor.base-directory = "~/Downloads";
    };
  };

  home.sessionPath = [ "$HOME/bin" ];

   home.sessionVariables = {
    EDITOR = "lvim";
    TERM = "kitty";
    BROWSER = "vivaldi";

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
