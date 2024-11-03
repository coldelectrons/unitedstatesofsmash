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
    environment.systemPackages = with pkgs; [
      kitty
      kitty-img
      pixcat
    ];

    # plusultra.home.configFile."kitty/kitty.ini".source = ./kitty.ini;
  };
}
