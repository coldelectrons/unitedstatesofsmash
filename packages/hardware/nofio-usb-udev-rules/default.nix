{
  lib,
  stdenv,
  makeWrapper,
}: 
with lib;
 stdenv.mkDerivation {
  pname = "nofio-usb-udev-rules";
  version = "0.0.1";

  src = ./nofio-usb.rules;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc/udev/rules.d
    install -D -m 644 $src $out/etc/udev/rules.d/70-nofio-usb.rules
    runHook postInstall
  '';

  meta = {
    description = "udev rules for Nofio wireless link.";
    platform = lib.platforms.linux;
    license = licenses.mit;
    # maintainers = [ coldelectrons ];
  };
}
