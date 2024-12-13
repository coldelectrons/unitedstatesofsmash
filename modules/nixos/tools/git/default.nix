{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.tools.git;
  user = config.${namespace}.user;
  # gpg = config.${namespace}.security.gpg;
in
{
  options.${namespace}.tools.git = {
    enable = mkEnableOption "Install and configure global git config";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    # signingKey = mkOpt types.str "The key ID to sign commits with.";
    # signByDefault = mkOpt types.bool true "Whether to sign commits by default.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git lazygit ];
    plusultra.home.extraOptions = {
      programs.git = {
        inherit (cfg) enable userName userEmail;
        lfs = enabled;
        # signing = {
        #   key = cfg.signingKey;
        #   inherit (cfg) signByDefault;
        # };
        config = {
          user = {
            name = cfg.userName;
            email = cfg.userEmail;
          };
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
        };
      };
      # Enable git authentication handler for OAuth
      programs.git-credential-oauth.enable = true;
      programs.lazygit.enable = true;
    };
  };
}
