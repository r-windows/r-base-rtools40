#!/bin/sh
# Minimal example of building R for Windows.
# You must run this script inside the rtools40 shell.
# This builds and checks a single architecture (no manuals or installer)
set -e
set -x

# Put pdflatex on the path (needed only for CMD check)
export PATH="$PATH:/c/progra~1/MiKTeX/miktex/bin/x64:/c/progra~1/MiKTeX 2.9/miktex/bin/x64"
pdflatex --version || true
texindex --version
make --version

# get absolute paths
srcdir=$(dirname $(realpath $0))

# Install system libs
pacman -Syu --noconfirm
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-{gcc,gcc-fortran,icu,libtiff,libjpeg,libpng,pcre2,xz,bzip2,zlib,cairo,tk,curl,libwebp}

# Download R-devel and extract (tarball contains recursive symlinks)
rm -Rf R-devel
curl -OL https://cran.r-project.org/src/base-prerelease/R-devel.tar.gz
MSYS="winsymlinks:lnk" tar -xf R-devel.tar.gz
cd R-devel

# Download a certificate bunle
curl https://curl.se/ca/cacert.pem > etc/curl-ca-bundle.crt

# Create the TCL bundle required by tcltk package
mkdir -p Tcl/{bin,lib}
${srcdir}/create-tcltk-bundle-ucrt.sh

# Add custom patches here:
# patch -Np1 -i "${srcdir}/myfix.patch" 

# Build just the core pieces (no manuals or installer)
cd "src/gnuwin32"
sed -e "s|mingw|ucrt|g" -e "s|@win@|64|" -e "s|@texindex@||" -e "s|@home32@||" "${srcdir}/MkRules.local.in" > MkRules.local
make all cairodevices recommended

# Optional: run checks
# make check-all

# Start RGUI to test
../../bin/x64/Rgui.exe &
