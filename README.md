# United States Of Smash

<a href="https://nixos.wiki/wiki/Flakes" target="_blank"><img alt="Nix Flakes Ready" src="https://img.shields.io/static/v1?logo=nixos&logoColor=d8dee9&label=Nix%20Flakes&labelColor=5e81ac&message=Ready&color=d8dee9&style=for-the-badge"></a>
<a href="https://github.com/snowfallorg/lib" target="_blank"><img alt="Built With Snowfall" src="https://img.shields.io/static/v1?logoColor=d8dee9&label=Built%20With&labelColor=5e81ac&message=Snowfall&color=d8dee9&style=for-the-badge"></a>
<a href="https://jakehamilton.github.io/config" target="_blank"><img alt="Frost Documentation" src="https://img.shields.io/static/v1?logoColor=d8dee9&label=Frost&labelColor=5e81ac&message=Documentation&color=d8dee9&style=for-the-badge"></a>

&nbsp;

> ✨ One (flake) for All (my installs)

- [Screenshots](#screenshots)
- [Overlays](#overlays)

## Screenshots

Nope.

## Overlays

See [Jake Hamilton's Config](https://github.com/jakehamilton/config) for details on how you might use his overlays in your own flake.

## What's up with this config?

Beware: NixOS has a learning curve similar to Dwarf Fortress. That is, it's a learning cliff.

I was just going to do a github-fork of `jakehamilton/config` (then called 'plusultra'), but because Nix configs are as personal as underwear and there was no reason for me to ever want to merge or make pull requests, I cut that link and started over.

I'm calling this config `unitedstatesofsmash`, because of the `plusultra` name/namespace, which made me think of All Might from My Hero Academy.

I'm not aiming for super-duper-autism-sparkly-Hyprland configs, hence no reason for screenshots.

Things I want out of this:
* Stick with stable channel for most things
    * Some things are too annoying when broken!
        * (now fixed) Steam (20241101, decimation PR in unstable, made it so Vulkan/Proton was borked)
* Overlay for newer packages <- this is the primary reason I wanted to copy `jakehamilton`'s snowfall config
    - (landed in 24.11) Kicad 8
    - (landed in 24.11) FreeCAD 1.0
    - (landed in 24.11) KDE Plasma 6.x
* Maybe a few of my own custom configs or dotfiles
    * Lunarvim
- Required system deployments/configs
    - desktop
    - laptop
    - file server
    - remote deployment ISOs

* Eventually, some other full system deployments
    * ~~raspberry pi 4/5 with Klipper configs~~ Argh screw pis
    * some tiny amd64 with Klipper configs

Things I have to figure out:
- [x] How to bootstrap with a snowfall flake config
    It's not hard, but there are many points of customization, NixAnon can't just clone this and expect it to work for them.
- [x] how to configure a user/users in a snowfall flake config
    I swear this wasn't in the snowfall docs when I first looked.
    This is one customization point: making a profile in `homes/<system_type>/<username>/default.nix`
- [x] how to deploy to a remote system using a snowfall flake config
    This isn't a mystery, all the known methods can work.
    There Is No One True Way(tm)

