{
  lib,
  pkgs,
  namespace,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook
}:

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "cmvs-pmvs";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "pmoulon";
    repo = "CMVS-PMVS";
    rev = "101c2ee3d7a28bedad7db65dcf63997ffb09678a";
    sha256 = "0y3aqa6lrwjwm60cm0mbqw9asdjfxzshvppzv758zl89gnq0azs0";
  };

  nativeBuildInputs = with pkgs.buildPackages; [
    autoPatchelfHook
    stdenv.cc.cc.lib
    pkg-config 
    cmake
  ];

  buildInputs = with pkgs; [
    # libjpeg
    # boost
    # eigen
    # cimg
  ];

  sourceRoot = ''${src.name}/program'';
  # installPhase = ''
  #   runHook preInstall
  #   install -m755 -D bin/VisualSFM $out/bin/visualsfm
  #   runHook postInstall
  # '';

  meta = with lib; {
    description = "SFM photogrammetry pipeline tools for sparse and dense reconstruction.";
    homepage = "https://github.com/pmoulon/CMVS-PMVS";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
