# Base R Installer [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/r-windows/r-base?branch=master)](https://ci.appveyor.com/project/jeroen/r-base)

> Building base R (ucrt) using rtools4

Scripts to build R for Windows using [Rtools40](https://github.com/r-windows/rtools-installer) toolchains. This script was used to build official releases and dalies for R 4.0 and 4.1. However as of R 4.2.0, the official CRAN releases for R for Windows are built privately by an R-core member, but the current repository and CI system will keep working.

## Build requirements

To build R for Windows yourself, you need:

 - [rtools40](https://cran.r-project.org/bin/windows/Rtools/)
 - [InnoSetup 6](https://www.jrsoftware.org/isdl.php) (only required for installer)
 - [MikTex](https://miktex.org/download) (only required for installer)

Rtools40 provides perl and all required system libraries so we no longer need any special "extsoft".

## How to build yourself

Clone or [download](https://github.com/r-windows/r-base/archive/master.zip) this repository. Optionally edit [`MkRules.local.in`](MkRules.local.in) to adjust compiler flags. Now open any rtools msys2 shell from the Windows start menu.

![win10](https://user-images.githubusercontent.com/216319/73364595-1fe28080-42ab-11ea-9858-ac8c660757d6.png)

### Option 1: Quick development build

The  [`./quick-build.sh`](quick-build.sh) script shows how to build a local single-architecture version of R from a source tarball.

To build, run the [`./quick-build.sh`](quick-build.sh) script inside the rtools40 bash shell. This will build a complete ucrt 64-bit version of R, but not manuals or the installer.

This is useful if you want to test a patch for base R. You can adjust the [`./quick-build.sh`](quick-build.sh) script to add patches.

### Option 2: build full installer

Alternatively run [`./full-build.sh`](full-build.sh) to build the complete installer as it would appear on CRAN. This requires you have innosetup and latex installed on your machine (in addition to rtools40). The process involves building R as well as pdf manuals and finally the installer program.
