# Maintainer: Jeroen Ooms <jeroen@berkeley.edu>

_realname=r-installer
pkgbase=${_realname}
pkgname="${_realname}"
pkgver=3.5.9000
pkgrel=1
pkgdesc="The R Programming Language"
arch=('any')
makedepends=("${MINGW_PACKAGE_PREFIX}-bzip2"
             "${MINGW_PACKAGE_PREFIX}-gcc"
             "${MINGW_PACKAGE_PREFIX}-gcc-fortran"
             "${MINGW_PACKAGE_PREFIX}-cairo"
             "${MINGW_PACKAGE_PREFIX}-curl"
             "${MINGW_PACKAGE_PREFIX}-icu"
             "${MINGW_PACKAGE_PREFIX}-libtiff"
             "${MINGW_PACKAGE_PREFIX}-libjpeg"
             "${MINGW_PACKAGE_PREFIX}-libpng"
             "${MINGW_PACKAGE_PREFIX}-pcre"
             "${MINGW_PACKAGE_PREFIX}-tcl"
             "${MINGW_PACKAGE_PREFIX}-tk"
             "${MINGW_PACKAGE_PREFIX}-xz"
             "${MINGW_PACKAGE_PREFIX}-zlib"
             "texinfo"
             "texinfo-tex"
             "sed")
options=('staticlibs')
license=("GPL")
url="https://www.r-project.org/"
source=(R-source.tar.gz::"https://cran.r-project.org/src/base-prerelease/R-devel.tar.gz"
    https://curl.haxx.se/ca/cacert.pem
    MkRules.local.in
    Renviron.site
    cairolibs.diff
    cranextra.diff
    shortcut.diff
    trio.diff
    static-tcl.diff
    rtools40.diff)

# Automatic untar fails due to embedded symlinks
noextract=(R-source.tar.gz)

sha256sums=('SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP')

prepare() {
  # Extract tarball with symlink workarounds
  rm -rf ${srcdir}/R-source
  mkdir -p ${srcdir}/R-source
  MSYS="winsymlinks:lnk" tar -xf ${srcdir}/R-source.tar.gz -C ${srcdir}/R-source --strip-components=1

  cd "${srcdir}/R-source"
  patch -Np1 -i "${srcdir}/cairolibs.diff"
  patch -Np1 -i "${srcdir}/cranextra.diff"
  patch -Np1 -i "${srcdir}/shortcut.diff"
  patch -Np1 -i "${srcdir}/trio.diff"
  patch -Np1 -i "${srcdir}/static-tcl.diff"
  patch -Np1 -i "${srcdir}/rtools40.diff" 
  cp "${srcdir}/cacert.pem" etc/curl-ca-bundle.crt

  # Temporary solution to hardcode new Rtools, disable binary pkgs
  cp ${srcdir}/Renviron.site etc/
  sed -i 's|ETC_FILES =|ETC_FILES = Renviron.site|' src/gnuwin32/installer/Makefile
  sed -i 's|PLATFORM_PKGTYPE|BLABLA|' src/main/Makefile.win
  
  # Extra Tcltk scripts go here?
  mkdir -p Tcl/{bin,lib}
}

build() {
  rm -Rf ${srcdir}/build32
  rm -Rf ${srcdir}/build64
  MSYS="winsymlinks:lnk" cp -Rf "${srcdir}/R-source" ${srcdir}/build32
  MSYS="winsymlinks:lnk" cp -Rf "${srcdir}/R-source" ${srcdir}/build64
  
  # Check that InnoSetup is installed 
  test -f "C:/Program Files (x86)/Inno Setup 5/ISCC.exe"
  
  # Put pdflatex on the path (assume Miktex 2.9)
  export PATH="$PATH:/c/progra~1/miktex~1.9/miktex/bin/x64"
  pdflatex --version
  texindex --version

  # Build 32 bit version
  cd "${srcdir}/build32/src/gnuwin32"
  sed -e "s|@win@|32|" -e "s|@texindex@||" -e "s|@home32@||" "${srcdir}/MkRules.local.in" > MkRules.local
  make 32-bit SHELL='sh -x'
  
  # Build 64 bit + docs and installers
  cd "${srcdir}/build64/src/gnuwin32"
  TEXINDEX=$(cygpath -m $(which texindex))  
  sed -e "s|@win@|64|" -e "s|@texindex@|${TEXINDEX}|" -e "s|@home32@|${srcdir}/build32|" "${srcdir}/MkRules.local.in" > MkRules.local
  make distribution
}

check(){
  export TCL_LIBRARY=$(cygpath -m ${MIGNW_PREFIX}/lib/tcl8.6)
  export TK_LIBRARY=$(cygpath -m ${MIGNW_PREFIX}/lib/tk8.6)
  cd "${srcdir}/build64/src/gnuwin32"
  make check-all
}

package() {
  cp ${srcdir}/build64/SVN-REVISION ${pkgdir}/
  cp -r ${srcdir}/build64/src/gnuwin32/cran ${pkgdir}/
}
