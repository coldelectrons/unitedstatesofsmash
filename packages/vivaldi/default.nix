{
  lib,
  makeDesktopItem,
  symlinkJoin,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) override-meta;

  vivaldi-wayland = makeDesktopItem {
    name = "Vivaldi (wayland)";
    desktopName = "Vivaldi (wayland)";
    genericName = "Vivaldi web browser (wayland)";
    categories = [
      "Network"
      "Internet"
    ];
    type = "Application";
    icon = "vivaldi";
    exec = "vivaldi --enable-features=UseOzonePlatform --ozone-platform=wayland --use-cmd-decoder=validating --use-gl=egl";
    terminal = false;
  };

  new-meta = with lib; {
    description = "Extra desktop items for running Vivaldi with wayland options.";
    license = licenses.asl20;
    maintainers = with maintainers; [ coldelectrons ];
  };

  package = symlinkJoin {
    name = "vivaldi-desktop-items";
    paths = [
      vivaldi-wayland
    ];
  };
in
override-meta new-meta package
