{
  lib,
  makeDesktopItem,
  namespace,
  ...
}:
let
  with-meta = lib.${namespace}.override-meta {
    platforms = lib.platforms.linux;
    description = "A desktop item to open Vivaldi in Plasma6 Wayland.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ coldelectrons ];
  };

  vivaldi = makeDesktopItem {
    name = "Vivaldi";
    desktopName = "Vivaldi";
    genericName = "Vivaldi web browser";
    icon = ./logo.svg;
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    exec = "vivaldi --enable-features=UseOzonePlatform --ozone-platform=wayland --use-cmd-decoder=validating --use-gl=egl";
    terminal = false;
  };
in
with-meta vivaldi 
