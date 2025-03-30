{
  lib,
  python3,
  freecad,
  fetchFromGitHub,
  pkgs
}:
let
  # cad-exchanger = fetchFromGitHub {
  #   owner = "yorikvanhavre";
  #   repo = "CADExchanger";
  #   rev = "5c2cd792ddc4581b917ebe7add5ef960bf6c3e2a";
  #   hash = "sha256-AST5bwhgMbvW3m8V1cv5PqKjJi2eSE1lbXpVLvRVzM8=";
  # };
  # open-theme = fetchFromGitHub {
  #   owner = "obelisk79";
  #   repo = "OpenTheme";
  #   rev = "80399168ab27c660a9a14812b67492f412f3148f";
  #   hash = "sha256-NgrBvP+wRNED3JI8zG9JMT//xfZfivQC8yy4m2GsujM=";
  # };
  # cfdOF = fetchFromGitHub {
  #   owner = "jaheyns";
  #   repo = "CfdOF";
  #   rev = "6a6a6ea7970265617fb9783e61d1a618cc4584b1";
  #   hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  # };
  # curved-shapes = fetchFromGitHub {
  #   owner = "chbergmann";
  #   repo = "CurvedShapesWorkbench";
  #   rev = "e7b94def50b7974518c2c89938bd6ccff08f4fc4";
  #   hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  # };
  btl = fetchFromGitHub {
    owner = "knipknap";
   repo = "better-tool-library";
    rev = "20271b23ca1c51d1955533765cadd98d705fab32";
    hash = "sha256-ZrQ4HUfw1KxfFSUOzS0bu0ULZ7Yj3rMqzXhglX9lMxY=";
  };
  cables = fetchFromGitHub {
    owner = "sargo-devel";
    repo = "Cables";
    rev = "v0.1.4";
    # https://github.com/sargo-devel/Cables/commit/09d5ab767dc63fc10600f46e84fe61db1483cb07
    hash = "sha256-aLsTPtS8NNpsHtZS21P189OAi0S3Wd4DcaOVLyjKiPQ=";
  };
  commandpanel = fetchFromGitHub {
    owner = "triplus";
    repo = "CommandPanel";
    rev = "c28ae6ee1345d39dad58560dfabc882a28772d2e";
    hash = "sha256-mxQKC9zT9q8N2PS1DjflXaA62UdXl7+SEqgvwBgVV5s=";
  };
  curves = fetchFromGitHub {
    owner = "tomate44";
    repo = "CurvesWB";
    rev = "52a36c01c65c7a98784b74050c8d72cf87bfb833";
    hash = "sha256-uAlIaooh8eK8RxmikCwzh+E2uoB1x1w3zHR0dedsNlg=";
  };
  defeaturing = fetchFromGitHub {
    owner = "easyw";
    repo = "Defeaturing_WB";
    rev = "cf4fc09bd1867ade81b6b0b24c001ace4d896fa3";
    hash = "sha256-+QpSwUk05KtfqoFBV0J+Ei+8YMJHQEhY+WIf4CiCzAk=";
  };
  em = fetchFromGitHub {
    owner = "ediloren";
    repo = "EM-Workbench-for-FreeCAD";
    rev = "6415cd6694a7a04dd451dbe4362bc38623958c45";
    hash = "sha256-vflcXhEmW1QZeuDFA59qFPmqzS1tJTlh1atEBRmT4Fs=";
  };
  feedsandspeeds = fetchFromGitHub {
    owner = "dubstar-04";
    repo = "FeedsAndSpeeds";
    rev = "b2cc0138d0e48758af91e5a82c4072108056cd5c";
    hash = "sha256-DQC5BQkZ/TuE7COShQlpyZm+28mJSy9VORKU1OXYjNI=";
  };
  freegrid = fetchFromGitHub {
    owner = "instancezero";
    repo = "in3dca-freegrid";
    rev = "8d7f94fca431c25d1f9b85e1012ad9d43ff6c79e";
    hash = "sha256-FKSYQ0BzNqpVH+Gddc/tTFSUxDlGUDJiYw8RcghGqnQ=";
  };
  workfeature = fetchFromGitHub {
    owner = "Rentlau";
    repo = "WorkFeature-WB";
    rev = "6f0bfe7f1c5f3a5906c3d2631400d396c2dab60e";
    hash = "sha256-7ejwUSKw8btjitOX7j+Y/9ohN364wXKA5KA5eizG1RQ=";
  };
  sheetmetal = fetchFromGitHub {
    owner = "shaise";
    repo = "FreeCAD_SheetMetal";
    rev = "2a7710e27da3ff91852a8e678df2160d2a0dbe87";
    hash = "sha256-nFc43p1E9v6nkd58tWcscF6soKh/3sZzZGeBaGQSU8s=";
  };
  partslibrary = fetchFromGitHub {
    owner = "FreeCAD";
    repo = "FreeCAD-library";
    rev = "8a6a19e1bfdaa85c2f368a20a803af6c4b51c43f";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA5=";
  };
  lattice2 = fetchFromGitHub {
    owner = "DeepSOIC";
    repo = "Lattice2";
    rev = "7cb85087a650f4f0b67d6d19562540e5d31e9bac";
    hash = "sha256-4yI/CUxoQ2CR671gZ1bS8uC/2bMJ6qDtYBpAVJ9qHh0=";
  };
  gears = fetchFromGitHub {
    owner = "looooo";
    repo = "freecad.gears";
    rev = "0c8d8d764bdc36f99a127065bdec4a38670dc0db";
    hash = "sha256-Z2ISj3FK1N4tZCxSyxF7IrKD4OfImtUOVK+mIc4IplI=";
  };
  fasteners = fetchFromGitHub {
    owner = "shaise";
    repo = "FreeCAD_FastenersWB";
    rev = "4b7a71cf0782d61d42f36afe515b2880e49dea80";
    hash = "sha256-4yCDz26gufpNzGfEj8CkGCToHznC7IUXEffLvlG+DXk=";
  };
  threadprofile = fetchFromGitHub {
    owner = "mwganson";
    repo = "ThreadProfile";
    rev = "e81768aa592f73419a8eab223817faaa2d2f6753";
    hash = "sha256-IeyNH+VTn2E1g3ovH7XQQMGVPtYZc8RaH3d9aP75x2A=";
  };
  reinforcement = fetchFromGitHub {
    owner = "amrit3701";
    repo = "FreeCAD-Reinforcement";
    rev = "0f181caa6b10f6cadf42411b63cca8d908c21122";
    hash = "sha256-WdFTXz8P2c3T+RIQ9EdVuQ47zWm4tuXXow3PULYVlig=";
  };
  quetzal = fetchFromGitHub {
    owner = "EdgarJRobles";
    repo = "quetzal";
    rev = "8f3297b2862d2267d3fb6c8d04d27bfbc0441da7";
    hash = "sha256-c3FvseUTPXLrDyIg/G2NjjymEQUMwm7mee9O3TACU2Y=";
  };
  nodes = fetchFromGitHub {
    owner = "j8sr0230";
    repo = "Nodes";
    rev = "9f7de2b2b4cb52e1fd0fb5dd1b805b31351c0f09";
    hash = "sha256-3hDqCFkBFli1bU9LG6gBjHIS9Eu0TUCQaL6LacKL80c=";
  };
  ribbon = fetchFromGitHub {
    owner = "APEbbers";
    repo = "FreeCAD-Ribbon";
    rev = "2d0d7dec063cebe135dc75f3428da905b4c28d76";
    hash = "sha256-YmMCjXGpphF1EkKQV1PViEi0qlkjg5xEXBjKcuwIHbQ=";
  };
  inventorloader = fetchFromGitHub {
    owner = "jmplonka";
    repo = "InventorLoader";
    rev = "e94bdf5e29052a0dc7ce6fdf755e956ae507caec";
    hash = "sha256-H840it8uelXxtBdQxUBvVuvZK3p+KIn26NcoI5SZh2I=";
  };

  freecad-customized = pkgs.plusultra.freecad.customize {
    modules = [
      btl
      cables
      commandpanel
      curves
      defeaturing
      em
      feedsandspeeds
      freegrid
      workfeature
      sheetmetal
      partslibrary
      lattice2
      gears
      fasteners
      threadprofile
      reinforcement
      quetzal
      # nodes
      ribbon
      inventorloader
    ];
    pythons = [
      (ps: with ps; [
        requests pyjwt tzlocal 
        # qtpy pkgs.plusultra.awkward # Nodes
        # pkgs.plusultra.pyqt-node-editor # Nodes
        xlrd xlwt olefile # InventorLoader
        # xlutils # InventorLoader, but isn't currently in nixpkgs
      ])
    ];
    # makeWrapperFlags = [ "--set-default" "QT_FONT_DPI" "85" ];
    # userCfg = ./my-default-config.cfg;
  };
in
freecad-customized
