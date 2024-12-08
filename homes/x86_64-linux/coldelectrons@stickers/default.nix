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
      name = "coldelectrons";
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
      # git = enabled // {
      #   userEmail = "frithomas@gmail.com";
      #   userName = "coldelectrons";
      # };
      direnv = enabled;
      # yubikeyTouchDetector = enabled;
    };
  };

  home.sessionPath = [ "$HOME/bin" ];

  home.stateVersion = "24.05";
}
