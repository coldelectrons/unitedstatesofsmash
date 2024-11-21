{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.cli-apps.atuin;

in
{
  options.${namespace}.cli-apps.atuin = {
    enable = mkEnableOption "Atuin command-line history";
  };

  config = mkIf cfg.enable {
    # services.atuin.enable = true;
    # environment.systemPackages = with pkgs; [ atuin ];
    programs.atuin = {
      enable = true;
      settings = {
        sync_frequency = "10m";
        inline_height = 16;
        keymap_mode = "vim-insert";
        keymap_cursor = {
          vim_insert = "blink-bar";
          vim_normal = "steady-block";
        };
        enter_accept = true;
        history_filter = [ "^gpg .*--edit-key=.+" "^gpg .*--recipient.+" ];
      };
    };
  };
}
