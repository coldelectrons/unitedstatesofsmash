{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "gcodeparser";
  version = "0.2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "AndyEveritt";
    repo = "GcodeParser";
    rev = "${version}";
    hash = "sha256-K4jKoiUv2DnjI7RXT7tqKF+SU/6S1d97qzNU+xyoS8U=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools ];

  pythonImportsCheck = [ "gcodeparser" ];

  meta = with lib; {
    description = "A simple gcode parser.";
    homepage = "https://github.com/AndyEveritt/GcodeParser";
    changelog = "https://github.com/AndyEveritt/GcodeParser/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
