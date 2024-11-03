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
  cfg = config.${namespace}.apps.simula;
  # Fetch Simula source code from GitHub
  simulaSrc = pkgs.fetchFromGitHub {
    owner = "SimulaVR";
    repo = "Simula";
    rev = "7497ada3e415299c88cefed9e58ffec8a654362e";
    sha256 = "04kqlgs740784642fbbypfyv3wa3ddqd9d764wadhjr36mf2rqi6";
    fetchSubmodules = true;
  };

  # Build the Simula package
  simula = pkgs.callPackage "${simulaSrc}/Simula.nix" {
    onNixOS = true;
    devBuild = false;
    profileBuild = false;
    externalSrc = simulaSrc;
  };
in
{
  options.${namespace}.apps.simula = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for Simula VR.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      simula
    ];
  };
}
