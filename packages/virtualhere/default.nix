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

  src = fetchurl {
    url = "https://www.virtualhere.com/sites/default/files/usbclient/vhuit64";
    hash = "sha256-1Y4oV0KlEyEzwV/IAulwxdk9fGfQk59m/GXTR0VeAAE=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    libGL
    egl-wayland
  ];

  buildInputs = with pkgs; [
    libGL
    egl-wayland
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p %out/bin
    install -m755 -D $src $out/bin/vhuit64
    runHook postInstall
  '';

  meta = with lib; {
    description = "VirtualHere usb-over-ethernet UI.";
    homepage = "https://virtualhere.com";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
