{ channels, inputs, ... }:

final: prev:

{ inherit (channels.unstable) webcamoid;
  disabledModules = [
    "pkgs/applications/video/webcamoid/default.nix"
  ];
  imports = [ "${channels.unstable}/pkgs/applications/video/webcamoid/default.nix" ];
}

