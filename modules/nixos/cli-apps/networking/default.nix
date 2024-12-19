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
  cfg = config.${namespace}.cli-apps.networking;
in
{
  options.${namespace}.cli-apps.networking = with types; {
    enable = mkBoolOpt false "Whether or not to enable command-line extras.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      aha
      dmidecode
      httpie # Better curl
      jq # JSON pretty printer and manipulator
      w3m
      dnsutils
      dnstracer
      httpie
      zdns
      sshfs
      dig
      nmap
      nload
    ];
  };
}
