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
  cfg = config.${namespace}.desktop.addons.kitty;
in
{
  options.${namespace}.desktop.addons.kitty = with types; {
    enable = mkBoolOpt false "Whether to enable the kitty terminal.";
  };

  config = mkIf cfg.enable {
    plusultra.desktop.addons.term = {
      enable = true;
      pkg = pkgs.kitty;
    };

    # plusultra.home.configFile."kitty/kitty.ini".source = ./kitty.ini;
  };
}
