{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gcodeparser";
  version = "0.2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "AndyEveritt";
    repo = "GcodeParser";
    rev = "${version}";
    hash = "";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "gcodeparser" ];

  meta = with lib; {
    description = "A simple gcode parser.";
    homepage = "https://github.com/AndyEveritt/GcodeParser";
    changelog = "https://github.com/AndyEveritt/GcodeParser/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
