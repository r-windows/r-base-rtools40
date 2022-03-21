# Maintainer: Jeroen Ooms <jeroen@berkeley.edu>

_realname=r-installer
pkgbase=${_realname}
pkgname="${_realname}"
pkgver=4.2.9000
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
             "${MINGW_PACKAGE_PREFIX}-libwebp"
             "${MINGW_PACKAGE_PREFIX}-pcre2"
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

# Default source is R-devel (override via $rsource_url)
source=(R-source.tar.gz::"${rsource_url:-https://cran.r-project.org/src/base-prerelease/R-devel.tar.gz}"
    https://curl.se/ca/cacert.pem
    MkRules.local.in
    shortcut.diff
    create-tcltk-bundle-ucrt.sh)

# Automatic untar fails due to embedded symlinks
noextract=(R-source.tar.gz)

sha256sums=('SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP')

prepare() {
  # Verify that InnoSetup is installed
  INNOSETUP="C:/Program Files (x86)/Inno Setup 6/ISCC.exe"
  msg2 "Testing for $INNOSETUP"
  test -f "$INNOSETUP"
  "$INNOSETUP" 2>/dev/null || true

  # Put pdflatex on the path (assume Miktex 2.9)
  msg2 "Checking if pdflatex and texindex can be found..."
  export PATH="$PATH:$HOME/AppData/Local/Programs/MiKTeX/miktex/bin/x64:/c/progra~1/MiKTeX/miktex/bin/x64:/c/progra~1/MiKTeX 2.9/miktex/bin/x64"
  pdflatex --version
  texindex --version

  # Extract tarball with symlink workarounds
  msg2 "Extracting R source tarball..."
  rm -rf ${srcdir}/R-source
  mkdir -p ${srcdir}/R-source
  MSYS="winsymlinks:lnk" tar -xf ${srcdir}/R-source.tar.gz -C ${srcdir}/R-source --strip-components=1
  cd "${srcdir}/R-source"

  # Ship the CA bundle
  cp "${srcdir}/cacert.pem" etc/curl-ca-bundle.crt

  # Ship the TclTk runtime bundle
  msg2 "Creating the TclTk runtime bundle"
  ${srcdir}/create-tcltk-bundle-ucrt.sh

  # Add your patches here
  patch -Np1 -i "${srcdir}/shortcut.diff"
}

build() {
  # Build 64 bit + docs and installers
  msg2 "Building 64-bit distribution"
  cd "${srcdir}/R-source/src/gnuwin32"
  TEXINDEX=$(cygpath -m $(which texindex))  
  sed -e "s|@texindex@|${TEXINDEX}|" "${srcdir}/MkRules.local.in" > MkRules.local
  make distribution
}

check(){
  #export R_CRAN_WEB="https://cran.rstudio.com"
  cd "${srcdir}/R-source/src/gnuwin32"
  echo "===== 64 bit checks ====="
  make check-all
}

package() {
  # Derive output locations
  REVISION=$((read x; echo ${x:10}) < "${srcdir}/R-source/SVN-REVISION")
  CRANDIR="${srcdir}/R-source/src/gnuwin32/cran"

  # This sets TARGET variable
  $(sed -e 's|set|export|' "${CRANDIR}/target.cmd")

  # Copy CRAN release files
  cp "${srcdir}/R-source/SVN-REVISION" "${pkgdir}/SVN-REVISION.${target}"
  cp "${CRANDIR}/NEWS.${target}.html" ${pkgdir}/
  cp "${CRANDIR}/README.${target}" ${pkgdir}/

  # Determine which webpage variant to ship from target (for example "R-3.4.1beta")
  case "$target" in
  *devel|*testing)
    cp "${CRANDIR}/rdevel.html" "${pkgdir}/"
    ;;
  *patched|*alpha|*beta|*rc)
    cp "${CRANDIR}/rpatched.html" "${pkgdir}/"
    cp "${CRANDIR}/rtest.html" "${pkgdir}/"
    ;;
  R-4*)
    cp "${CRANDIR}/index.html" "${pkgdir}/"
    cp "${CRANDIR}/md5sum.txt" "${pkgdir}/"
    cp "${CRANDIR}/rw-FAQ.html" "${pkgdir}/"
    cp "${CRANDIR}/release.html" "${pkgdir}/"
    REVISION="$target"
    ;;
  *)
    echo "Unknown release type: $target"
    exit 1
    ;;
  esac

  # Helper for appveyor script
  echo "set revision=${REVISION}" >> "${CRANDIR}/target.cmd"
  cp "${CRANDIR}/target.cmd" ${pkgdir}/
}
