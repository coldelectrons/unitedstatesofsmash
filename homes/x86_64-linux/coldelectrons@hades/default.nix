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
    };

    cli-apps = {
      zsh = enabled;
      tmux = enabled;
      neovim = enabled;
      lunarvim = enabled;
      home-manager = disabled;
    };

    tools = {
      git = enabled;
      direnv = enabled;
    };
  };

  home.sessionPath = [ "$HOME/bin" ];

  home.stateVersion = "24.05";
}
