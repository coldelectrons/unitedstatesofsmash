{ channels, inputs, ... }:

final: prev:

{ inherit (channels.unstable) prusa-slicer;
  disabledModules = [
    "pkgs/applications/misc/prusa-slicer/default.nix"
  ];
  imports = [ "${channels.unstable}/pkgs/applications/misc/prusa-slicer/default.nix" ];
}
