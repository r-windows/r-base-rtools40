#!/usr/bin/env bash
cd "$(dirname "$0")"

# Update system
pacman -Syyu
pacman -S --needed --noconfirm mingw-w64-{i686,x86_64}-{gcc,gcc-fortran}
pacman -S --needed --noconfirm mingw-w64-{i686,x86_64}-{icu,libtiff,libjpeg,libpng,pcre,xz,bzip2,zlib}
pacman -S --needed --noconfirm mingw-w64-{i686,x86_64}-{cairo,tk,curl}

# Build package
makepkg-mingw
