{
  options,
  config,
  pkgs,
  lib,
  inputs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.nix;

  substituters-submodule = types.submodule (
    { name, ... }:
    {
      options = with types; {
        key = mkOpt (nullOr str) null "The trusted public key for this substituter.";
      };
    }
  );
in
{
  # This module adds everything a sane Nix[OS] installation should have
  options.${namespace}.nix = with types; {
    enable = mkBoolOpt true "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.lix "Which nix package to use.";

    default-substituter = {
      url = mkOpt str "https://cache.nixos.org" "The url for the substituter.";
      key =
        mkOpt str "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "The trusted public key for the substituter.";
    };

    extra-substituters = mkOpt (attrsOf substituters-submodule) { } "Extra substituters to configure.";
  };

  config = mkIf cfg.enable {
    assertions = mapAttrsToList (name: value: {
      assertion = value.key != null;
      message = "plusultra.nix.extra-substituters.${name}.key must be set";
    }) cfg.extra-substituters;

    # TODO use sudo-rs instead?
    # XXX doas seems too...weird and broken
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };


    environment.systemPackages = with pkgs; [
      git
      wget
      plusultra.nixos-revision
      (plusultra.nixos-hosts.override { hosts = inputs.self.nixosConfigurations; })
      deploy-rs
      nixfmt-rfc-style
      nix-index
      nix-prefetch-git
      nix-output-monitor
      # flake-checker # FIXME 20241126 fails to build with 24.11
      snowfallorg.drift
      nurl
    ];

    nix =
      let
        users = [
          "root"
          config.${namespace}.user.name
        ] ++ optional config.services.hydra.enable "hydra";
      in
      {
        package = cfg.package;

        settings =
          {
            experimental-features = "nix-command flakes";
            http-connections = 50;
            warn-dirty = false;
            log-lines = 50;
            sandbox = "relaxed";
            auto-optimise-store = true;
            trusted-users = users;
            allowed-users = users;

            substituters = [
              cfg.default-substituter.url
            ] ++ (mapAttrsToList (name: value: name) cfg.extra-substituters);
            trusted-public-keys = [
              cfg.default-substituter.key
            ] ++ (mapAttrsToList (name: value: value.key) cfg.extra-substituters);
          }
          // (lib.optionalAttrs config.${namespace}.tools.direnv.enable {
            keep-outputs = true;
            keep-derivations = true;
          });

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };

        # flake-utils-plus
        generateRegistryFromInputs = true;
        generateNixPathFromInputs = true;
        linkInputs = true;
      };
  };
}
