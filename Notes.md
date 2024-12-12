### modules/[home|nixos]/tools/git
These are originally from Jake Hamilton's config.
I was/am confused as to why there needed to be nearly identicle modules.
The answer may lie in the fact the JH made seeminly all his systems rely
on `doas` instead of `sudo`.

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


