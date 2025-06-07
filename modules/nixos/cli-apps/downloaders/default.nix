{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli-apps.downloaders;
in
{
  options.${namespace}.cli-apps.downloaders = with types; {
    enable = mkBoolOpt false "Whether or not to enable command-line download tools.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gallery-dl # 20250330 failed in unstable
      yt-dlp
      youtube-tui
      tartube-yt-dlp
      # ytmdl
      yaydl
      yewtube
    ];
  };
}
