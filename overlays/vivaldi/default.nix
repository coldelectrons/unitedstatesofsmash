{ channels, ... }:

final: prev:

{ 
  vivaldi =  (prev.vivaldi.overrideAttrs ( oldAttrs: {
    dontWrapQtApps = false;
    proprietaryCodecs = true;
    enableWidevine = true;
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
      channels.nixpkgs.kdePackages.wrapQtAppsHook ];
  }));
}
