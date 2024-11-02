{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.cli-apps.lunarvim;
in
{
  options.${namespace}.cli-apps.lunarvim = {
    enable = mkEnableOption "lunarvim";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        less
        lunarvim
        neovide
        neovim
        zk
        stylua
        libclang
      ];

      sessionVariables = {
        PAGER = "less";
        MANPAGER = "less";
        NPM_CONFIG_PREFIX = "$HOME/.npm-global";
        EDITOR = "nvim";
      };

      shellAliases = {
        vimdiff = "nvim -d";
      };
    };

    xdg.configFile = {
      "dashboard-nvim/.keep".text = "";
    };

    home.file = {
      ".config/lvim/config.lua" = {
        source = ./config.lua;
      };
      ".local/bin/lvimide" = {
        source = ./lvimide;
      };
    };
  };
}
