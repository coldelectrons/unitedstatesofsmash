# General
* My desktop config mostly works. Things that I'm currently ~~banging my head against the wall~ working on:
  * VR
    * In particular, trying to get Nofio/Index working
      * 20250330 Not working
      * I've gone as far as booting a Windows10 install (yuck) and update the firmware on all my VR devices.
      * Considering that Nofio uses Virtualhere, and VH uses usbip on linux, I thought I might just configure usbip directly.
        However:
        * VH uses port 7575, which is not the default for usbip
        * I don't know the USB VID:PID that VH is using
        * If VH _is_ working, maybe Monado isn't picking up those devices?
        * VirtualHere documentation/forums is contradictory: It says it uses usbip on linux, but the author also says in one forum reply that he wrote his own better protocol[^1].
        * The VH client is closed source, and I don't know enough yet to package the GUI client
      * Further testing:
        I can run `vhclientx86_64` CLI as a daemon
        It finds the base after the usb network starts
        using the LIST command shows:
          name      vh address      server host:port
        `IMRNext (2a3613f855a1) (imr-nofio1:7575)`
        However, it does not see or add any devices, nor does `AUTO USE HUB,IMRNext` do anything:
  * Steam games
    * I've not made this a high priority.
    * Since switching to Plasma6/wayland, making games run has become even more of a chore.
      * I shouldn't have to configure gamescope for every single game!
    * I've tried using `steamtinkerlaunch`, but that's just trading one flavor of poor documentation and obscurity for another
    * Is SteamVR abandonware until the Deckard launch?
  * `nix-env --install xxx` - DO NOT USE THIS
    * IT FUCKS WITH SHIT
    * IT CURVES YOUR SPINE
    * IT WARPS YOUR SOUL
    * IT MAKES IT LOOK LIKE YOUR FLAKE DID NOT WORK

## TODO
- [ ] Move TODO to it's own file
- [ ] Start working in branches/merges in git instead of spamming commits like a crazy person.
    - [ ] Make the branches rename the Nixos generation they build to help discern them
- [ ] ~~Beat Steam like a little bitch~~ Make Steam tell me what's wrong.
- [x] Get VR working with the Index
    - [ ] Move the Nofio stuff to it's own branch
    - [ ] Make Steam use Monado/Opencomposite
        - [ ] Get Alyx working
            - I've played through Alyx on Debian. It worked great! C'mon, this shouldn't be so hard in NixOS!
        - [ ] Get some virtual desktop working, like Simula
        - [ ] Longshot: Steam VR games with Vorpx.
    - The Valve Deckard is coming, or failing that get a BSB2
- [ ] FreeCAD customization
    - ~~I swear to god if they break my spacenav again I'm going to go berzerk~~
    - [ ] Use the new `freecad.customize`
        Currently doesn't handle macros.
        FreeCAD doesn't have `pip` in NixOS, and thus the AddonManager can't install dependencies
        - [ ] Just add `pip` and be done with it?
        - [ ] Just add the dependencies for the addons I want, and use AddonManager?
        - [ ] Write some nix modules for doing the addons and handling the dependencies
        - Problematic addons:
            - [ ] Nodes
                - Uses Python `awkward` module, which in `nixpkgs-unstable` requires at least `python312`
                - FreeCAD is still using `python311` in `nixpkgs-unstable`
            - [ ] InventorLoader
                - uses `python-xlsutils`, which isn't in `nixpkgs`
    - [ ] Make a `freecad-git` package?
        - If only it had an override for the python version
        - Tried this already, using `python312Packages`, and gets a bunch of (more) cryptic errors
        - definitely something to move to it's own branch or flake

### modules/[home|nixos]/tools/git
These are originally from Jake Hamilton's config.
I was/am confused as to why there needed to be nearly identicle modules.
The answer may lie in the fact the JH made seeminly all his systems rely on `doas` instead of `sudo`.
`doas` (when I looked at it) isn't really an active project, and there are
github issues about how it causes problems with NixOS, particularly with
not propagating the user's environment into the new shell.
E.g. you want to `doas nixos-rebuild blah-blah-blah`, and while your user
might have `git` available, the superuser would not, and the command would
fail for not finding `git`.

The identicle modules may be a way of patching that behavior. I don't like it,
particularly because it make such a configuration harder to understand.
Also, there are other `sudo` replacements available which don't seem to have
the same problems.


[^1]: Better? Yeah, right.
