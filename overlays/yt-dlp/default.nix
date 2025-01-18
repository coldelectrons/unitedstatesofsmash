{ channels, ... }:

final: prev:

# 20250103 due to a bug with curl-cffi, `--impersonate` is not available in 24.11
# the patch was merged into nixpkgs:master, but not yet in unstable
{ inherit (channels.unstable) yt-dlp; }
