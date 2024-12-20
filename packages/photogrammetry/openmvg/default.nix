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

  env = {
  #   OpenMVG_BUILD_EXAMPLES = "OFF"; # hopefully we don't need to DL the rerun sdk
    CFLAGS = "-Wno-error";
    CXXFLAGS = "-Wno-error";
  };
  cmakeFlags = [
    "-Wno-dev"
    "-DOpenMVG_BUILD_EXAMPLES=OFF"
    "-DOpenMVG_USE_OPENCV=ON"
    "-DCLP_INCLUDE_DIR_HINTS=${pkgs.clp}"
    "-DOSI_INCLUDE_DIR_HINTS=${pkgs.osi}"
    "-DCOINUTILS_INCLUDE_DIR_HINTS=${pkgs.coin-utils}"
    # "-DFLANN_INCLUDE_DIR_HINTS=${pkgs.flann}"
    "-DLEMON_INCLUDE_DIR_HINTS=${pkgs.lemon-graph}"
  ];

  nativeBuildInputs = with pkgs.buildPackages; [
    # autoPatchelfHook
    stdenv.cc.cc.lib
    pkg-config 
    cmake
    # extra-cmake-modules
    libsForQt5.wrapQtAppsHook
  ];

  # propagatedBuildInputs = with pkgs; [ graphiz ];
  buildInputs = with pkgs; [
    qt5.full
    eigen
    ceres-solver
    libpng
    libjpeg
    libtiff
    xorg.libXxf86vm
    xorg.xrandr
    zlib
    # lz4
    # python3Packages.rerun-sdk
    # rerun
    coinmp # ???
    coin-utils
    clp
    osi
    python3
    wget
    ghostscript
    doxygen
    lemon-graph
    flann
    nanoflann
    cereal
    sphinx
    opencv
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
    license = licenses.mpl20;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
