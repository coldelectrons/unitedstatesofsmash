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
  cfg = config.${namespace}.apps.comfyui;
  # my-comfyui = pkgs.comfyuiPackages.comfyui.override {
  #   extensions = [
  #     pkgs.comfyuiPackages.extensions.acly-inpaint
  #     pkgs.comfyuiPackages.extensions.acly-tooling
  #     pkgs.comfyuiPackages.extensions.cubiq-ipadapter-plus
  #     pkgs.comfyuiPackages.extensions.fannovel16-controlnet-aux
  #   ];
  #   commandLineArgs = [
  #     "--preview-method"
  #     "auto"
  #   ];
  # };
in
{
  options.${namespace}.apps.comfyui = with types; {
    enable = mkBoolOpt false "Whether or not to enable comfyui.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # comfyuiPackages.comfyui-with-extensions
      # my-comfyui
      # comfyuiPackages.krita-with-extensions
    ];
  };
}
