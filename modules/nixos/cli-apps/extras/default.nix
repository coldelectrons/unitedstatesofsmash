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
    enable = mkBoolOpt false "Whether or not to enable command-line extras.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      aha
      toilet # Display fancy text in terminal
      # dwt1-shell-color-scripts # Display cool graphics in terminal
      # cmatrix # Show off the Matrix
      timer # Cooler timer in terminal
      tree
      tldr # better man pages
      dmidecode
      perl
      comma # Install and run programs by sticking a , before them
      distrobox # Nice escape hatch, integrates docker images with my environment
      bc # Calculator
      ripgrep # Better grep
      fzf
      fd # Better find
      diffsitter # Better diff
      jq # JSON pretty printer and manipulator

      gnugrep gnused
      pandoc
      bitwarden-cli
      appimage-run
      hw-probe
      cyme # a better lsusb
      usbview
      clinfo
      ltex-ls # Spell checking LSP
    ];
  };
}
