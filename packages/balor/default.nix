{
  lib,
  python3,
  fetchFromGitLab,
}:
let
  extraBuildInputs = plugins python3.pkgs;
in
python3.pkgs.buildPythonApplication rec {
  pname = "balor";
  version = "0.1";

  src = fetchFromGitLab {
    # https://gitlab.com/bryce15/balor
    domain = "gitlab.com";
    owner = "bryce15";
    repo = "balor";
    rev = "dfc7fafb703cf7f85f396d066847a5a0544015e2";
    sha256 = "1qwlvv7gllh38g1iv8xrn4ar7r3mkp0z2kwpydiivqb0ban6dq1v";
  };

  format = "other";

  installPhase = ''
    mkdir -p $out/opt
    cp -r ./* $out/opt
    chmod +x $out/opt/balor*.py
    makeWrapper $out/opt/balor.py $out/bin/balor --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-code-debug.py $out/bin/balor-code-debug --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-aligner.py $out/bin/balor-aligner --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-code.py $out/bin/balor-code --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-fiducial.py $out/bin/balor-fiducial --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-ngc.py $out/bin/balor-ngc --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-raster.py $out/bin/balor-raster --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-sender.py $out/bin/balor-sender --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-svg.py $out/bin/balor-svg --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-test.py $out/bin/balor-test --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/balor-text.py $out/bin/balor-text --prefix PYTHONPATH : "$PYTHONPATH"
    makeWrapper $out/opt/drawanimatedsquare.py $out/bin/drawanimatedsquare --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  propogatedBuildInputs = with python3.pkgs; [
    usb
    svg-path
    numpy
    pillow
    scipy
    plusultra.gcodeparser
  ];

  meta = with lib; {
    description = "Command-line utilities to operate BJJCZ-compatible laser galvo machines.";
    homepage = "https://gitlab.com/bryce15/balor";
    changelog = "";
    license = licenses.gpl3;
    maintainers = with maintainers; [ coldelectrons ];
    mainProgram = "balor";
  };
}
