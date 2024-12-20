{
  lib,
  pkgs,
  namespace,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook
}:

# assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "openmvg";
  version = "v2.1_sablefish";

  src = fetchFromGitHub {
    owner = "openMVG";
    repo = "openMVG";
    rev = "c16fa098824b7fdba39305248ee9eacbed6ec173";
    sha256 = "0x4vllisfqnnz23q1g642pi12jgdnda2ij33375rdirnrlav8mnv";
    fetchSubmodules = true;
  };
  sourceRoot = "${src.name}/src/";

  nativeBuildInputs = with pkgs.buildPackages; [
    autoPatchelfHook
    stdenv.cc.cc.lib
    pkg-config 
    cmake
  ];

  propagatedBuildInputs = with pkgs; [ graphiz ];
  buildInputs = with pkgs; [
    libsForQt5
    libsForQt5.qt5.wrapQtAppsHook
    libpng
    libjpeg
    libtiff
    xorg.libXxf86vm
    xorg.xrandr
  ];


  # installPhase = ''
  #   runHook preInstall
  #   install -m755 -D bin/VisualSFM $out/bin/visualsfm
  #   runHook postInstall
  # '';

  meta = with lib; {
    description = "OpenMVG structure-from-motion photogrammetry app.";
    homepage = "https://github.com/openMVG/openMVG";
    platforms = platforms.linux;
    license = licenses.mpl2;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
