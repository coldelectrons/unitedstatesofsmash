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
  cfg = config.${namespace}.cli-apps.nix;
in
{
  options.${namespace}.cli-apps.nix = with types; {
    enable = mkBoolOpt false "Whether or not to enable extra command-line Nix tools.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Nix Tools
      nil # Nix LSP
      nixfmt-classic # Nix formatter
      nvd # Differ
      nix-output-monitor
      nh # Nice wrapper for NixOS and HM
      nixpkgs-review
      nix-prefetch-github # prefetch tool for Github
    ];
  };
}
