{ channels, ... }:

final: prev:

{ 
  flatcam =  (prev.flatcam.overrideAttrs ( oldAttrs: {
    pname = "flatcam-beta";
    version = "unstable-2024-10-10";
    src = prev.lib.fetchFromBitBucket {
      owner = "marius_stanciu";
      repo = "FlatCAM_beta";
      # branch = "Beta_8.995";
      rev = "1ef01840d00eaad9dbd906832911ef63c0748625";
      hash = "sha256-hxIrpD0Z+XInr/rnQqjbXa8dpHceGlgwFOk8y2zObZ4=";
    };
    # dontWrapQtApps = false;
    # proprietaryCodecs = true;
    # enableWidevine = true;
    # nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
    #   channels.unstable.kdePackages.wrapQtAppsHook ];
  }));
}
