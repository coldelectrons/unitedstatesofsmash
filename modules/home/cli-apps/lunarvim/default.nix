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
    enable = mkEnableOption "lunarvim user config";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        less
        lunarvim
        neovide
        # neovim
        zk
        stylua
        libclang
        fzf
        ripgrep
        glow
      ];

      sessionVariables = {
        NPM_CONFIG_PREFIX = "$HOME/.npm-global";
        EDITOR = "lvim";
      };

    };

    xdg.configFile = {
      "dashboard-nvim/.keep".text = "";
    };

    home.file = {
      ".config/lvim/config.lua" = {
        enable = true;
        source = ./config.lua;
      }; 
      ".local/bin/lvimide" = {
        enable = true;
        source = ./lvimide;
        executable = true;
      };
    };
  };
}
