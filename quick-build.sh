#!/bin/sh
# Minimal example of building R for Windows.
# You must run this script inside the rtools40 shell.
# This builds and checks a single architecture (no manuals or installer)
set -e
set -x

# Put pdflatex on the path (needed only for CMD check).
export PATH="${PATH}:/c/progra~1/MiKTeX/miktex/bin/x64:/c/progra~1/MiKTeX 2.9/miktex/bin/x64"
# If it's on a personal Windows and MiKTeX is installed manually, it's usually a "private install," which locates here
export PATH="${HOME}/AppData/Local/Programs/MiKTeX/miktex/bin/x64/:${PATH}"

# The main tools are in /x86_64-w64-mingw32.static.posix in Rtools42
export PATH="/c/rtools42/x86_64-w64-mingw32.static.posix/bin:/c/rtools42/usr/bin:${PATH}"

# Confirm the PATH is set up correctly
pdflatex --version || true
texindex --version
make --version

# On Rtools42, tar is not the tweaked version, so this option is needeed instead
export TAR="/usr/bin/tar"
export TAR_OPTIONS="--force-local"

# get absolute paths
srcdir=$(dirname $(realpath $0))

# The required system libs are already installed in Rtools42. If some additional lib is required, uncomment here.
# pacman -Syu --noconfirm
# pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-{gcc,gcc-fortran,icu,libtiff,libjpeg,libpng,pcre2,xz,bzip2,zlib,cairo,tk,curl,libwebp}

# Download Tcl
curl -OL https://www.r-project.org/nosvn/winutf8/ucrt3/Tcl.zip

# Download R-devel and extract (tarball contains recursive symlinks)
rm -Rf R-devel
curl -OL https://cran.r-project.org/src/base-prerelease/R-devel.tar.gz
MSYS="winsymlinks:lnk" tar -xf R-devel.tar.gz
cd R-devel
unzip "${srcdir}/Tcl.zip"

# Add custom patches here:
# patch -Np1 -i "${srcdir}/myfix.patch" 

# Build just the core pieces (no manuals or installer)
cd "src/gnuwin32"
# Use the default MkRules.local if Rtools42
# sed -e "s|mingw|ucrt|g" -e "s|@win@|64|" -e "s|@texindex@||" -e "s|@home32@||" "${srcdir}/MkRules.local.in" > MkRules.local
make rsync-recommended
make all cairodevices recommended

# Optional: run checks
# make check-all

# Start RGUI to test
../../bin/x64/Rgui.exe &
