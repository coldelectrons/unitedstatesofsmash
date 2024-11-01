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
  cfg = config.${namespace}.apps.mpd;
in
{
  options.${namespace}.apps.mpv = with types; {
    enable = mkBoolOpt false "Whether or not to enable mpv.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mpv
      mpvScripts.thumbfast
      # mpvScripts.uosc
      mpvScripts.mpv-cheatsheet
      mpvScripts.mpris
      mpvScripts.modernx
    ];
    # programs.mpv = {
    #   enable = true;
    #   #bindings = { };
    #   scripts = with pkgs.mpvScripts; [
    #     mpris
    #     vr-reversal
    #     sponsorblock
    #     uosc
    #     thumbfast
    #     quality-menu
    #     webtorrent-mpv-hook
    #     visualizer
    #   ];
    #   config = {
    #     # Video format/quality that is directly passed to youtube-dl
    #     ytdl-format = "bestvideo+bestaudio";
    #     # Controls which type of graphics APIs will be accepted
    #     gpu-api = "auto";
    #     # Keep the player open
    #     keep-open = "yes";
    #     # Determines wether the window is auto-resized to fit the video
    #     auto-window-resize = "no";
    #     # Sets window size
    #     geometry = "800x600";
    #     # Set startup volume
    #     volume = 40;

    #     # Whether to load the on-screen-controller
    #     osc = "no";
    #     # Disable for uosc
    #     osd-bar = "no";
    #   };
    #   scriptOpts = {
    #     uosc = {
    #       volume_size = 30;
    #       # Display style of current position. available: line, bar
    #       timeline_style = "bar";
    #     };
    #   };
    # };
  };
}
