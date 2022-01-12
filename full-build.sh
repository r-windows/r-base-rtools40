#!/usr/bin/env bash
cd "$(dirname "$0")"

# Cleanup
rm -rf src pkg

# Update system
echo 'Server = https://ftp.opencpu.org/rtools/ucrt64/' > /etc/pacman.d/rtools.ucrt64
echo 'SigLevel = Never' >> /etc/pacman.d/rtools.ucrt64
pacman -Syyu --noconfirm
if [ "$rversion" == "r-devel" ]; then
export MINGW_ARCH="ucrt64"
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-{icu,libtiff,libjpeg,libpng,pcre2,xz,bzip2,zlib,cairo,tk,curl,libwebp}
else
_archs=""
export MINGW_ARCH="mingw64"
pacman -S --needed --noconfirm mingw-w64-{i686,x86_64}-{icu,libtiff,libjpeg,libpng,pcre2,xz,bzip2,zlib,cairo,tk,curl,libwebp}
fi

# Build package (only once)
set -o pipefail
makepkg-mingw 2>&1 | tee r-devel.log

# Copy installer to root directory
cp -f src/R-source/src/gnuwin32/installer/*.exe .
