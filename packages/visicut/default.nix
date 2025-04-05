{ lib, stdenv, fetchzip, makeWrapper, wrapGAppsHook, glib, jdk11 }:

stdenv.mkDerivation rec {
  pname = "VisiCut";
  version = "2.1-12-g1357f643";

  src = fetchzip {
    url = "https://github.com/t-oster/VisiCut/releases/download/continuous/${pname}-${version}.zip";
    sha256 = "sha256-b84OlXmiuQ/irmE78S5Yp2s8xgIaWJKOXmQ785o8S2Y=";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];
  buildInputs = [ glib jdk11 ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    rm ${pname}.{exe,Linux,MacOS}
    mkdir -p $out/share/icons
    cp -r . $out/share/${pname}
    cp examples/Basic/visicut-icon.png $out/share/icons/visicut.png

    mkdir -p $out/share/applications
    echo "
[Desktop Entry]
Name=VisiCut
Comment=A userfriendly tool to create, save and send Jobs to a Lasercutter
Comment[de]=Ein benutzerfreundliches Tool zum Erstellen, Speichern und Senden von Jobs an einen Lasercutter
Exec=$out/bin/VisiCut.Linux %F
Icon=visicut
Terminal=false
Type=Application
Categories=Graphics;VectorGraphics;GTK;
MimeType=image/vnd.dxf;image/svg+xml;image/x-eps;image/jpeg;image/png;application/x-plf;application/x-ls;
StartupNotify=true" > $out/share/applications/VisiCut.desktop

    runHook postInstall
  '';

  # Needs to be run in fixupPhase, since gappsWrapperArgs are not fully
  # populated in installPhase yet.
  postFixup = ''
    makeWrapper \
        ${jdk11}/bin/java \
        $out/bin/${pname}.Linux \
        --add-flags "-Xms256m -Xmx2048m -jar $out/share/${pname}/Visicut.jar" \
        "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "A userfriendly tool to prepare, save and send Jobs to Lasercutters";
    homepage = "https://visicut.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
