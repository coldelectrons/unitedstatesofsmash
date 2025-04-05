{ lib, stdenv, fetchzip, makeWrapper, wrapGAppsHook, glib, jdk11 }:

stdenv.mkDerivation rec {
  pname = "VisiCut";
  version = "2.1";

  src = fetchzip {
    url = "https://download.visicut.org/files/master/All/${pname}-${version}.zip";
    sha256 = "sha256-gviwJYYNFLv9w27mLbti2BD+08pd1B/bEIluf11IVM8=";
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
