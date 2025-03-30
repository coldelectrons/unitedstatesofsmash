{
  lib,
  # fetchFromGitLab,
  python3Packages,
  # qt5,
  # pyqt5,
  # setuptools,
}:

python3Packages.buildPythonPackage rec {
  pname = "pyqt-node-editor";
  version = "v0.9.14";
  # pyproject = true;

  src = lib.fetchFromGitLab {
    owner = "pavel.krupala";
    repo = "pyqt-node-editor";
    tag = version;
    hash = "";
  };

  # nativeBuildInputs = [
    # setuptools
    # qt5.wrapQtAppsHook
  # ];

  propagatedBuildInputs = with python3Packages; [
    qtpy
  ];

  nativeCheckInputs = with python3Packages; [ qtpy pyqt5 ];

  # dontWrapQtApps = true;

  # pythonImportsCheck = [ "node_scene" "node_node" "node_graphics_view" ];

  # TODO add desktop file
  # postInstall = ''
  #   install -Dm644 node-editor.desktop -t $out/share/applications/
  #   install -Dm644 $out/${python.sitePackages}/rare/resources/images/Rare.png $out/share/pixmaps/rare.png
  # '';

  # preFixup = ''
  #   makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  # '';

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "A node editor Python package using Qt5";
    homepage = "https://gitlab.com/pavel.krupala/pyqt-node-editor";
    maintainers = [ ];
    license = licenses.mit;
    platforms = platforms.linux;
    # mainProgram = "";
  };
}
