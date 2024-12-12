{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.tools.git;
  user = config.${namespace}.user;
in
{
  options.${namespace}.tools.git = {
    enable = mkEnableOption "Install and configure global git config";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    # signingKey = mkOpt types.str "The key ID to sign commits with.";
    # signByDefault = mkOpt types.bool true "Whether to sign commits by default.";
  };

# FIXME(wtf) It seems silly to have near-identical home/nixos modules
# jakehamilton did it, but why is it necessary
# the nixos module can do more stuff, and puts HM config into ${namespace}.home.extraOptions
  config = mkIf cfg.enable {
    programs.git = {
      inherit (cfg) enable userName userEmail;
      lfs = enabled;
      # signing = {
      #   key = cfg.signingKey;
      #   inherit (cfg) signByDefault;
      # };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        push = {
          autoSetupRemote = true;
        };
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
        # credential = {
        #   helper = "oauth";
        # };
        # credential.helper = "cache --timeout 21600"; # six hours
      };
    };
    # Enable git authentication handler for OAuth
    programs.git-credential-oauth.enable = inherit (cfg) enable;
    programs.lazygit.enable = inherit (cfg) enable;
  };
}
