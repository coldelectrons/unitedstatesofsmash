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
  cfg = config.${namespace}.apps.vivaldi;
  defaultSettings = {
    # "browser.aboutwelcome.enabled" = false;
    # "browser.meta_refresh_when_inactive.disabled" = true;
    # "browser.startup.homepage" = "https://hamho.me";
    # "browser.bookmarks.showMobileBookmarks" = true;
    # "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    # "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    # "browser.aboutConfig.showWarning" = false;
    # "browser.ssb.enabled" = true;
  };
in
{
  options.${namespace}.apps.vivaldi = with types; {
    enable = mkBoolOpt false "Whether or not to enable vivaldi.";
    extraConfig = mkOpt str "" "Extra configuration for the user profile JS file.";
    userChrome = mkOpt str "" "Extra configuration for the user chrome CSS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
  };

  config = mkIf cfg.enable {

    plusultra.home = {

      extraOptions = {
        programs.vivaldi = {
          enable = true;
          dictionaries = with pkgs; [ hunspellDictsChromium.en_US ];
          commandLineArgs = [
            "--force-dark-mode"
            "--enable-force-dark"
            "--enable-features=WebUIDarkMode"
          ];
          extensions = [
            # Bypass Paywalls Clean
            {
              id = "lkbebcjgcmobigpeffafkodonchffocl";
              updateUrl =
                "https://gitlab.com/magnolia1234/bypass-paywalls-chrome-clean/-/raw/master/updates.xml";
            }
            { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # UBlock Origin
            { id = "gebbhagfogifgggkldgodflihgfeippi"; } # Return Dislikes
            { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # Sponsor Block
            # { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeepassXC
            { id = "ponfpcnoihfmfllpaingbgckeeldkhle"; } # Enhancer for YouTube
            # { id = "fonfeflegdnbhkfefemcgbdokiinjilg"; } # Chat Replay
            { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
            # { id = "hmgpakheknboplhmlicfkkgjipfabmhp"; } # Pay
            # { id = "bmnlcjabgnpnenekpadlanbbkooimhnj"; } # Honey
            { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # Plasma Browser Integration
            { id = "fkagelmloambgokoeokbpihmgpkbgbfm"; } # Indie Wiki Buddy
            { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylus
            # { id = "nenlahapcbofgnanklpelkaejcehkggg"; } # Save Now
          ];
        };
      };
    };
  };
}
