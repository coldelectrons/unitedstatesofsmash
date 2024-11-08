{ channels, ... }:

final: prev:

{ final.vivaldi = prev.vivaldi.overrideAttrs
  (oldAttrs: {
    dontWrapQtApps = false;
    dontPatchELF = true;
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [prev.pkgs.kdePackages.wrapQtAppsHook];
  });
}
