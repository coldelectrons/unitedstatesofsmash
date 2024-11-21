inputs@{
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
  cfg = config.${namespace}.cli-apps.eza;
in
{
  options.${namespace}.cli-apps.eza = with types; {
    enable = mkBoolOpt false "Whether or not to enable eza.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      eza
    ];

    environment.variables = {
      # PAGER = "page";
      # MANPAGER =
      #   "page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p|set ft=man'";
      PAGER = "less";
      MANPAGER = "less";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      EDITOR = "nvim";
    };

    plusultra.home = {
      configFile = {
        "dashboard-nvim/.keep".text = "";
      };

      extraOptions = {
        # Use eza for Git diffs.
        programs.zsh.shellAliases.vimdiff = "nvim -d";
        programs.bash.shellAliases.vimdiff = "nvim -d";
        programs.fish.shellAliases.vimdiff = "nvim -d";
      };
    };
  };
}
