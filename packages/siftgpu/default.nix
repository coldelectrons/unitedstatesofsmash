{
  lib,
  pkgs,
  namespace,
  stdenv,
  fetchFromGitHub,
  # autoPatchelfHook
}:

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation {
  name = "siftgpu";
  version = "0.5.400";

  src = fetchFromGitHub {
    owner = "coldelectrons";
    repo = "SiftGPU";
    rev = "90e9f4c1fcc8ebcc592b3c5b43d60bd4b4ba3560";
    sha256 = "188qmh9a5f3z32afaab6k2ck28qrf4mjn3p1wnxlmwg0mkkfk7sj";
  };

  nativeBuildInputs = with pkgs.buildPackages; [
    pkg-config 
    # autoPatchelfHook
    stdenv.cc.cc.lib
  ];

  buildInputs = with pkgs; [
    mesa_glu 
    freeglut
    libdevil
  ];

  sourceRoot = ".";

  # installPhase = ''
  #   runHook preInstall
  #   install -m755 -D bin/VisualSFM $out/bin/visualsfm
  #   runHook postInstall
  # '';

  meta = with lib; {
    description = "SiftGPU - A GPU implementation of David Lowe's Scale Invariant Feature Transform";
    homepage = "https://github.com/pitzer/SiftGPU";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
