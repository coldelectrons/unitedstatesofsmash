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
  cfg = config.${namespace}.cli-apps.extras;
in
{
  options.${namespace}.cli-apps.extras = with types; {
    enable = mkBoolOpt false "Whether or not to enable command-line extras for the Kitty terminal.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      toilet # Display fancy text in terminal
      # dwt1-shell-color-scripts # Display cool graphics in terminal
      # cmatrix # Show off the Matrix
      timer # Cooler timer in terminal
      tree
      tldr # better man pages
      comma # Install and run programs by sticking a , before them
      bc dc clac# Calculators

      termpdfpy # graphical reader for inside kitty
      termimage # display images in the term
      viu
      kitty-img
      pixcat
      wl-clipboard

    ];
  };
}
