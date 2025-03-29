
{ channels, ... }:

final: prev:
{
  linux-firmware = prev.linux-firmware.overrideAttrs (prev: {
    version = "20250211";
    src = pkgs.fetchzip {
    url = "https://web.git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-76e258534a5db6c54c0ac1bf97c3fe15e61ffc6e.tar.gz";
    hash = "sha256-0q9smlm5sjyqi8z5a8k5d8vv25ds22lcn4yxj03k80paagwir0yd=";
    };
  });
}
