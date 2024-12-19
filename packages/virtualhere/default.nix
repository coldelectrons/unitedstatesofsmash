{
  lib,
  stdenv,
  pkgs,
  fetchurl,
  # libGL,
  # egl-wayland,
  autoPatchelfHook
}:

stdenv.mkDerivation rec {
  name = "virtualhere";
  version = "1.0.0";

  # TODO make selective download based on system
  src =
    if stdenv.isx86_64
    then
      fetchurl {
        url = "https://www.virtualhere.com/sites/default/files/usbclient/vhuit64";
        hash = "sha256-1Y4oV0KlEyEzwV/IAulwxdk9fGfQk59m/GXTR0VeAAE=";
      }
    else
      fetchurl {
        url = "";
        hash = "";
      };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    libGL
    egl-wayland
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D vhuit64 $out/bin/vhuit64
    runHook postInstall
  '';

  meta = with lib; {
    description = "VirtualHere usb-over-ethernet UI.";
    homepage = "https://virtualhere.com";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
