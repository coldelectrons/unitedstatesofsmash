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
  cfg = config.${namespace}.cli-apps.extras;
in
{
  options.${namespace}.cli-apps.extras = with types; {
    enable = mkBoolOpt false "Whether or not to enable command-line extras.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      smartmontools
      aha
      toilet # Display fancy text in terminal
      # dwt1-shell-color-scripts # Display cool graphics in terminal
      # cmatrix # Show off the Matrix
      timer # Cooler timer in terminal
      tree
      tldr # better man pages
      entr # run commands when files change!
      dmidecode
      perl
      ventoy-full # bootable USB solution
      comma # Install and run programs by sticking a , before them
      distrobox # Nice escape hatch, integrates docker images with my environment
      bc # Calculator
      ncdu # TUI disk usage
      ripgrep # Better grep
      fzf
      fd # Better find
      httpie # Better curl
      diffsitter # Better diff
      jq # JSON pretty printer and manipulator

      gnugrep gnused
      libnotify
      hwinfo
      unzip
      w3m
      pandoc
      bitwarden-cli
      appimage-run
      lvm2
      ctmg
      # cryptomator
      dnsutils
      dnstracer
      zdns
      hw-probe
      cyme # a better lsusb
      usbview
      clinfo
      usbimager
      rpi-imager
      sshfs

      ltex-ls # Spell checking LSP

      mdcat # cat for markdown
      termpdfpy # graphical reader for inside kitty
      presenterm # terminal slideshow
      slides
      mdp # markdown presentation
      termimage # display images in the term
      viu
      kitty-img
      pixcat
      nb # note book
      neofetch disfetch lolcat cowsay onefetch starfetch
      wl-clipboard
      glow

      # Nix Tools
      nil # Nix LSP
      nixfmt-classic # Nix formatter
      nvd # Differ
      nix-output-monitor
      nh # Nice wrapper for NixOS and HM
      nixpkgs-review
      nix-prefetch-github # prefetch tool for Github

      gallery-dl # datahoarding ftw
      yt-dlp
      signald
      signal-export
      scli

      # terminal file managers, because while I like mc
      # it doesn't seem to work right with fish or zsh
      mc
      lf
      walk
      fm-go
      joshuto
      superfile
      sfm
    ];
    programs.yazi = {
      enable = true;
    };
  };
}
