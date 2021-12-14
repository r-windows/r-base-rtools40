#!/usr/bin/env bash
cd "$(dirname "$0")"

# Cleanup
rm -rf src pkg

# Update system
if [ "$rversion" == "r-devel" ]; then
_archs="ucrt-x86_64"
export MINGW_ARCH="ucrt64"
else
_archs="{i686,x86_64}"
export MINGW_ARCH="mingw64"
fi
pacman -Syyu --noconfirm
pacman -S --needed --noconfirm mingw-w64-${_archs}-{icu,libtiff,libjpeg,libpng,pcre2,xz,bzip2,zlib,cairo,tk,curl,libwebp}

# Build package (only once)
set -o pipefail
makepkg-mingw 2>&1 | tee r-devel.log

# Copy installer to root directory
cp -f src/R-source/src/gnuwin32/installer/*.exe .
