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
  cfg = config.${namespace}.cli-apps.markdown;
in
{
  options.${namespace}.cli-apps.markdown = with types; {
    enable = mkBoolOpt false "Whether or not to enable command-line markdown tools.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mdcat # cat for markdown
      presenterm # terminal slideshow
      slides
      mdp # markdown presentation
      nb # note book
      glow
    ];
  };
}
