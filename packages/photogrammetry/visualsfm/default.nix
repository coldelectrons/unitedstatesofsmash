{
  lib,
  pkgs,
  namespace,
  stdenv,
  fetchurl,
  autoPatchelfHook
}:

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "visualsfm";
  version = "0.5.25";

  src = fetchurl {
    url = "http://ccwu.me/vsfm/download/VisualSFM_linux_64bit.zip";
    sha256 = "1nfjc9w1xr4kgrbbys9m0yrqxj8bm53m4wvp6mhxibp5g8kgqaq5";
  };

  nativeBuildInputs = with pkgs.buildPackages; [
    pkgs.unzip
    autoPatchelfHook
    stdenv.cc.cc.lib
    pkg-config 
    pkgs.plusultra.siftgpu
    pkgs.plusultra.cmvs-pmvs
  ];

  buildInputs = with pkgs; [
    unzip 
    gtk2 
    mesa_glu 
  ];

  sourceRoot = "./vsfm/";

  installPhase = ''
    runHook preInstall
    install -m755 -D bin/VisualSFM $out/bin/visualsfm
    runHook postInstall
  '';

  meta = with lib; {
    description = "VisualSFM structure-from-motion photogrammetry app.";
    homepage = "https://visualsfm.com";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
