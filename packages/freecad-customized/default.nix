{
  lib,
  python3,
  freecad,
  fetchFromGitHub
}:
let
  cad-exchanger = fetchFromGitHub {
    owner = "yorikvanhavre";
    repo = "CADExchanger";
    rev = "5c2cd792ddc4581b917ebe7add5ef960bf6c3e2a";
    hash = "sha256-AST5bwhgMbvW3m8V1cv5PqKjJi2eSE1lbXpVLvRVzM8=";
  };
  open-theme = fetchFromGitHub {
    owner = "obelisk79";
    repo = "OpenTheme";
    rev = "80399168ab27c660a9a14812b67492f412f3148f";
    hash = "sha256-NgrBvP+wRNED3JI8zG9JMT//xfZfivQC8yy4m2GsujM=";
  };
  cfdOF = fetchFromGitHub {
    owner = "jaheyns";
    repo = "CfdOF";
    rev = "6a6a6ea7970265617fb9783e61d1a618cc4584b1";
    hash = "";
  };
  curved-shapes = fetchFromGitHub {
    owner = "chbergmann";
    repo = "CurvedShapesWorkbench";
    rev = "e7b94def50b7974518c2c89938bd6ccff08f4fc4";
    hash = "";
  };
  btl = fetchFromGitHub {
    owner = "knipknap";
    repo = "better-tool-library";
    rev = "20271b23ca1c51d1955533765cadd98d705fab32";
    hash = "";
  };
  cables = fetchFromGitHub {
    owner = "sargo-devel";
    repo = "Cables";
    rev = "v0.1.4";
    # https://github.com/sargo-devel/Cables/commit/09d5ab767dc63fc10600f46e84fe61db1483cb07
    hash = "";
  };
  CommandPanel = {
    owner = "triplus";
    repo = "CommandPanel";
    rev = "c28ae6ee1345d39dad58560dfabc882a28772d2e";
    hash = "";
  };
  CurvedShapesWorkbench = {
    owner = "chbergmann";
    repo = "CurvedShapesWorkbench";
    rev = "e7b94def50b7974518c2c89938bd6ccff08f4fc4";
    hash = "";
  };
  CurvesWB = {
    owner = "tomate44";
    repo = "CurvesWB";
    rev = "52a36c01c65c7a98784b74050c8d72cf87bfb833";
    hash = "";
  };
  Defeaturing_WB = {
    owner = "easyw";
    repo = "Defeaturing_WB";
    rev = "cf4fc09bd1867ade81b6b0b24c001ace4d896fa3";
    hash = "";
  };
  EM-Workbench-for-FreeCAD = {
    owner = "ediloren";
    repo = "EM-Workbench-for-FreeCAD";
    rev = "6415cd6694a7a04dd451dbe4362bc38623958c45";
    hash = "";
  };
  FeedsAndSpeeds = {
    owner = "dubstar-04";
    repo = "FeedsAndSpeeds";
    rev = "b2cc0138d0e48758af91e5a82c4072108056cd5c";
    hash = "";
  };
  in3dca-freegrid = {
    owner = "instancezero";
    repo = "in3dca-freegrid";
    rev = "8d7f94fca431c25d1f9b85e1012ad9d43ff6c79e";
    hash = "";
  };
  WorkFeature = {
    owner = "Rentlau";
    repo = "WorkFeature";
    rev = "02b5217be9a8ec1e2987d6cada0f78fbe41da5b9";
    hash = "";
  };
  WorkFeature-WB = {
    owner = "Rentlau";
    repo = "WorkFeature-WB";
    rev = "6f0bfe7f1c5f3a5906c3d2631400d396c2dab60e";
    hash = "";
  };
  FreeCAD_SheetMetal = {
    owner = "shaise";
    repo = "FreeCAD_SheetMetal";
    rev = "2a7710e27da3ff91852a8e678df2160d2a0dbe87";
    hash = "";
  };
  FreeCAD-library = {
    owner = "FreeCAD";
    repo = "FreeCAD-library";
    rev = "8a6a19e1bfdaa85c2f368a20a803af6c4b51c43f";
    hash = "";
  };
  Lattice2 = {
    owner = "DeepSOIC";
    repo = "Lattice2";
    rev = "7cb85087a650f4f0b67d6d19562540e5d31e9bac";
    hash = "";
  };
  freecad.gears = {
    owner = "looooo";
    repo = "freecad.gears";
    rev = "0c8d8d764bdc36f99a127065bdec4a38670dc0db";
    hash = "";
  };
  FreeCAD_FastenersWB = {
    owner = "shaise";
    repo = "FreeCAD_FastenersWB";
    rev = "4b7a71cf0782d61d42f36afe515b2880e49dea80";
    hash = "";
  };
  ThreadProfile = {
    owner = "mwganson";
    repo = "ThreadProfile";
    rev = "e81768aa592f73419a8eab223817faaa2d2f6753";
    hash = "";
  };
  FreeCAD-Reinforcement = {
    owner = "amrit3701";
    repo = "FreeCAD-Reinforcement";
    rev = "0f181caa6b10f6cadf42411b63cca8d908c21122";
    hash = "";
  };
  quetzal = {
    owner = "EdgarJRobles";
    repo = "quetzal";
    rev = "8f3297b2862d2267d3fb6c8d04d27bfbc0441da7";
    hash = "";
  };
  Nodes = {
    owner = "j8sr0230";
    repo = "Nodes";
    rev = "9f7de2b2b4cb52e1fd0fb5dd1b805b31351c0f09";
    hash = "";
  };
  FreeCAD-Ribbon = {
    owner = "APEbbers";
    repo = "FreeCAD-Ribbon";
    rev = "2d0d7dec063cebe135dc75f3428da905b4c28d76";
    hash = "";
  };
  InventorLoader = {
    owner = "jmplonka";
    repo = "InventorLoader";
    rev = "e94bdf5e29052a0dc7ce6fdf755e956ae507caec";
    hash = "";
  };

  freecad-customized = freecad.customize {
    modules = [  ];
    pythons = [
      (ps: with ps; [
        requests pyjwt tzlocal 
        qtpy awkward plusultra.pyqt-node-editor # Nodes
        # xlrd xlwt # InventorLoader
        # xlutils olefileio # InventorLoader, but aren't currently in nixpkgs
      ])
    ];
    makeWrapperFlags = [ "--set-default" "QT_FONT_DPI" "85" ];
    userCfg = ./my-default-config.cfg;
  };
in
freecad-customized
