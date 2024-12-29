{
  lib,
  stdenv,
  makeWrapper,
}: 
with lib;
 stdenv.mkDerivation {
  pname = "lmc-usb-udev-rules";
  version = "0.0.1";

  src = ./lmc-usb.rules;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc/udev/rules.d

    install -D -m 644 $src $out/etc/udev/rules.d/70-lmc-usb.rules

    runHook postInstall
  '';

    # substituteInPlace $out/etc/udev/rules.d/70-lmc-usb.rules \
    #   --replace "lmc2loader" "${lmc2loader}/bin/lmc2loader"

  # TODO package the lmc firmware uploader

  meta = {
    description = "udev rules for BJZPCB-compatible laser control boards.";
    long_description = ''
      Udev rules that give non-root access to BJZ galvo laser control boards.

      USBLMCv4 needs no further handling.
      LMCv2 varieties need a firmware blob uploaded.
    '';
    platform = platforms.linux;
    license = licenses.unfree;
    # maintainers = [ coldelectrons ];
  };
}
