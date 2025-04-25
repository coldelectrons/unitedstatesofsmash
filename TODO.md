* Re-organize module substructure?
    * It's not very obvious to new user what is essential and what is customization that could be cut
    * It's not very obvious what essential things need to be set for a new fork
        * need some document pointing out the settings here and how they tie in with snowfall documentation
    * Just make a barebones version?
        * Didn't jakehamilton do this already? How useful was it? (not much IIRC)
    * Why?
      Nixconfigs are as personal as underwear!
      Some people wear boxers, some wear briefs!
      If someone doesn't like my thong made of human hair, then don't borrow it, you weirdo!
      You have to wash it first!
      Besides, anyone who has made it here has to have climbed the NixOS learning cliff!
* VR!
    * 20250419 It's working!
      The problems I was having came from stuff I `nix-env --install`'d.
      There needs to be either a bigger warning on that tool, or a means to see what derivations are being masked/displaced.
      Cleared everything out with `nix-env --remove *`
        - [x] * xrgears
        - [ ] * hello_xr - still need to figure out the right options
        - lovr - need to make a nix package
        - [ ] some kind of xr desktop
            - [ ] stardust
            - [ ] simula
            - [ ] wlx-overlay
        - working setups
            - [x] standalone monado
            - [ ] monado/opencomposite
                - [ ] standalone
                - [ ] for proton in steam
                - [ ] for wine in lutris
                - [ ] for wine/proton in umu-launcher
            - monado/steamvr?
                - there exists the `steamvr-monado` plugin from monado
                    - the `vrpathreg.sh addriver` can work, if I use `steam-run`, I don't have to use nix-ld
                        - BUT I still need to have the correct path to plugin
                            - in the nix store?
                            - in the steam fhsenv?
                            - can I make an activation script like for the steam cap_sys_nice fix?
    * Need a better method for launching things
      Using systemd units and desktop items to launch is very clunky, and doesn't indicate status at all
* FreeCAD! With all the addons!
    * one thing at a time, me!
* Tailscale!
  Can I do it declaritively?
* Secrets!
  Already started, needs to be documented in case I ~~forget~~ need to rebuild

