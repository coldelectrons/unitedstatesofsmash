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
      email = "frithomas@gmail.com"; # TODO put this into secrets
      # home = "/home/coldelectrons";
    };

    cli-apps = {
      zsh = enabled;
      atuin = enabled;
      lunarvim = enabled;
      home-manager = enabled;
    };

    tools = {
      git = enabled // {
        userEmail = "frithomas@gmail.com";
        userName = "coldelectrons";
      };
      direnv = enabled;
    };
  };

  home.sessionPath = [ "$HOME/bin" ];

  home.stateVersion = "24.05";
}
