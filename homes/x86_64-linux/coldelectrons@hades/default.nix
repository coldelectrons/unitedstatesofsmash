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
      home = "/home/coldelectrons/";
    };

    cli-apps = {
      zsh = enabled;
      lunarvim = enabled;
      home-manager = disabled;
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
