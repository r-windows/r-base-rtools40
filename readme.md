# Base R Installer

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/r-windows/r-testing?branch=master)](https://ci.appveyor.com/project/jeroen/r-testing) 
[![Download](https://api.bintray.com/packages/rtools/installer/testing/images/download.svg)](https://dl.bintray.com/rtools/installer/R-testing-win.exe)

> Test build of base R with rtools40

Scripts and patches to build R for Windows with the [new Rtools40 toolchains](https://github.com/r-windows/rtools-installer) for testing your R packages. This version automatically gets built, checked, and deployed every day to http://dl.bintray.com/rtools/installer/.

## Requirements

To build a R for Windows you need:

 - [rtools40](https://github.com/r-windows/docs/blob/master/rtools40.md)
 - [InnoSetup 6](https://www.jrsoftware.org/isdl.php) (only required to build the full installer)
 - [MikTex 2.9](https://cloud.r-project.org/bin/windows/Rtools/basic-miktex-2.9.7152-x64.exe)

Rtools40 contains a copy of perl and all required system libraries so we no longer need a custom "extsoft" bundle.

## How to build yourself

Clone this repository. Optionally edit [`MkRules.local.in`](MkRules.local.in) to adjust compiler flags. Now open any rtools msys2 shell from the Windows start menu.

Run the  [`./quick-build.sh`](quick-build.sh) inside the rtools40 shell to do a quick single-architecture build + check. This will build the complete 64-bit version of R, but not 32-bit R and also not manuals or the installer.

Alternatively run [`./full-build.sh`](full-build.sh) to build the complete installer as it appears on CRAN. This involves building both 32 and 64 bit R, as well as pdf manuals and the installer program. This can take about 2 hours and requires you have innosetup and latex installed on your machine (in addition to rtools40).

## Using R-testing 

This build of R has been customized to use the new rtools:

 - Automatically put rtools40 location on the `PATH`
 - Only install packages from source (CRAN binaries may not be compatible yet)
 - Packages are installed in `~/R/win-library/testing`

It should work out of the box if rtools 40 is installed, and not conflict with other R installations.
