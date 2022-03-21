#!/usr/bin/env bash
cd "$(dirname "$0")"

# Cleanup
rm -rf src pkg

# Update system
pacman -Syyu --noconfirm
export MINGW_ARCH="ucrt64"
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-{icu,libtiff,libjpeg,libpng,pcre2,xz,bzip2,zlib,cairo,tk,curl,libwebp}

# Build package (only once)
set -o pipefail
makepkg-mingw 2>&1 | tee r-devel.log

# Copy installer to root directory
cp -f src/R-source/src/gnuwin32/installer/*.exe .
