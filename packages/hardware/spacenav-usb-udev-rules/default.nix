{
  lib,
  stdenv,
  makeWrapper,
}: 
 stdenv.mkDerivation {
  pname = "spacenav-usb-udev-rules";
  version = "0.0.1";

  src = ./spacenav-usb.rules;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc/udev/rules.d
    install -D -m 644 $src $out/etc/udev/rules.d/70-spacenav-usb.rules
    runHook postInstall
  '';

  meta = {
    description = "udev rules for Connexion usb Spacenav 3d mice.";
    long_description = ''
      Udev rules that give non-root access to Connexion Spacenav 3d mice products.
    '';
    platforms = platforms.linux;
    license = license.mit;
    maintainers = [ coldelectrons ];
  };
};
