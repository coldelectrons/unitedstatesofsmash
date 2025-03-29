
{ channels, ... }:

final: prev:
{
  linux-firmware = prev.linux-firmware.overrideAttrs (prev: {
    version = "20250311";
    src = channels.nixpkgs.fetchzip {
      url = "https://web.git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-20250311.tar.gz";
      hash = "sha256-ZM7j+kUpmWJUQdAGbsfwOqsNV8oE0U2t6qnw0b7pT4g=";
    };
  });
}
