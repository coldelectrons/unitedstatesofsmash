{
  lib,
  stdenv,
  pkgs,
  fetchurl,
  config,
  autoPatchelfHook
}:
stdenv.mkDerivation rec {
  name = "virtualhere-cli";
  version = "5.8.5";

  src = fetchurl {
    url = "https://www.virtualhere.com/sites/default/files/usbclient/vhclientx86_64";
    sha256 = "1264hwyv5f4ip3s4r1y8kqvsn357q2rrsb9n3z6z5hizixk14ap3";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # TODO how to make this depend on the utilities in the following package
  buildInputs = [ pkgs.linuxKernel.packages.linux_xanmod.usbip ]; 

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p %out/bin
    install -m755 -D $src $out/bin/vhclientx86_64
    runHook postInstall
  '';

  meta = with lib; {
    description = "VirtualHere usb-over-ethernet CLI client.";
    homepage = "https://virtualhere.com";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
