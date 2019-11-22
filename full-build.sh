#!/usr/bin/env bash
cd "$(dirname "$0")"

# Cleanup
rm -rf src pkg

# Build package (only once)
set -o pipefail
pacman -Syyu --noconfirm
MINGW_INSTALLS="mingw32" makepkg-mingw --noconfirm --noprogressbar --skippgpcheck --nocheck --syncdeps --printsrcinfo
MINGW_INSTALLS="mingw64" makepkg-mingw --noconfirm --noprogressbar --skippgpcheck --nocheck --syncdeps --cleanbuild 2>&1 | tee r-devel.log
